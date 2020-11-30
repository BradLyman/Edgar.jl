"""
This module is an adapter to the AWS Lex Runtime. It provides
application-specific types and definitions for values returned by that service.

The main entrypoint for this module is the `PostText` method which returns a
`LexResponse`.
"""
module LexRuntime

using AWS: @service
using AWS: AWSConfig
using AWS: global_aws_config
using AWS.AWSServices: lex_runtime_service

export LexResponse

include("./DialogStates.jl")
include("./Intents.jl")

const botAlias = "alpha"
const botName = "TrialScheduler"

"""
A structured representation of the AWS Lex service's response. Data which isn't
used by this application is not included.
"""
struct LexResponse{DS <: DialogState, I <: Intent}
    dialog_state::DS
    intent::I
    slots::AbstractDict{String, String}
    message::Union{Some{String}, Nothing}
end

"Build a Lex Response from the raw return values from the lex service."
function build_response(raw::AbstractDict)::LexResponse
    @debug "$raw"

    message = raw["message"] === nothing ?
        nothing :
        Some(raw["message"])

    slots = raw["slots"] === nothing ?
        Dict{String, String}() :
        Dict{String, String}( k => string(v) for (k, v) in raw["slots"] )

    dialog_state = get(DialogStateNames, raw["dialogState"], Failed())
    intent = get(IntentNames, raw["intentName"], NothingIntent())

    LexResponse(dialog_state, intent, slots, message)
end

"Post a user's message to the conversational lex bot."
function PostText(user_message::String, userId::String)::LexResponse
    lex_runtime_service(
        "POST",
        "/bot/$(botName)/alias/$(botAlias)/user/$(userId)/text",
        Dict{String, Any}("inputText"=>user_message);
        aws_config=global_aws_config()
    ) |> build_response
end

end

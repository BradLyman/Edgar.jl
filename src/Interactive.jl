"""
This module is responsible for managing an interactive conversation with a
user. Conversation messages are handled and resolved into BotActions which can
either continue the conversation or manipulate the bot's state in some way.
"""
module Interactive

using ..Edgar

include("./lex/LexRuntime.jl")
using .LexRuntime

"""
Handle a conversational message by resolving it into a bot action.
UserId is a unique id for the conversation. This could be a channel identifier,
a server identifyer, or an actual user identifier, whatever makes sense based
on the message's origin.
"""
function handle(message::AbstractString, userId::AbstractString)::BotAction
    response = LexRuntime.PostText(message, userId)
    @debug "got $response from Lex runtime service"

    handle_response(response)
end

"Typical case message handler."
function handle_response(response::LexResponse{<:DialogState, <:Intent})
    to_bot_action(response.message)
end

"Convert an empty/nonexistent message into a bot action."
to_bot_action(::Nothing) = NoAction()

"Convert an actual human-readable message into a bot action."
to_bot_action(message::Some{String}) = Reply(something(message))

"Fulfill a CreateTrial intent."
function handle_response(response::LexResponse{ReadyForFulfillment, CreateTrial})
    CreateTrialPost(
        trialname=response.slots["TrialTitle"],
        trialdate=response.slots["TrialDate"],
        trialtime=response.slots["TrialTime"]
    )
end

end # end Lex Module

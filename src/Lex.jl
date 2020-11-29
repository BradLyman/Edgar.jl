"""
This module is an adapter to the Lex AWS service. It's purpose is to encapsulate
and isolate interactions through the AWS sdk.
"""
module Lex

using ..Edgar

const alias = "alpha"
const bot = "TrialScheduler"

using AWS: @service
@service Lex_Runtime_Service

export PostText;

function PostText(message::AbstractString, userId::AbstractString)::BotAction
    response = Lex_Runtime_Service.post_text(alias, bot, message, userId)
    @debug "got $response from Lex runtime service"

    dialog_state = response["dialogState"]
    if dialog_state == "ReadyForFulfillment"
        handle_fulfillment(response)
    elseif dialog_state == "Failed"
        NoAction()
    else
        handle_other_state(response)
    end
end

function handle_fulfillment(response::AbstractDict)::BotAction
    @debug "fulfill $(response["intentName"])"
    if response["intentName"] == "CreateTrial"
        @debug "creating a trial action"
        CreateTrialPost(
            trialname=response["slots"]["TrialTitle"],
            trialdate=response["slots"]["TrialDate"],
            trialtime=response["slots"]["TrialTime"]
        )
    else
        @warn "unknown intent, taking no action"
        NoAction()
    end
end

function handle_other_state(response::AbstractDict)::BotAction
    @debug "handle other dialog state $response"
    if response["message"] !== nothing
        Reply(response["message"])
    else
        @warn "can't dialog state $(response["dialogState"]) without a message"
        NoAction()
    end
end

end # end Lex Module

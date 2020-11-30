function take_action(::Discord.Client, ::Discord.Message, action::BotAction)
    @error "Unsupported action $action"
end

function take_action(
    client::Discord.Client,
    message::Discord.Message,
    create_trial_post::CreateTrialPost
)
    trial_post = """
    Trial - $(create_trial_post.trialname)
    $(create_trial_post.trialdate) :: $(create_trial_post.trialtime)

    Tanks:

    Healers:

    DPS:

    Or something, idfk
    """

    create_message(client, message.channel_id, content=trial_post)
end

"""
Create a message as a reply to the provided discord message.
"""
function take_action(client::Discord.Client, message::Discord.Message, reply::Reply)
    create_message(client, message.channel_id, content=reply.content)
end

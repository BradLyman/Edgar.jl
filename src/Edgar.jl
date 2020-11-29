module Edgar

include("./Types.jl")
include("./Lex.jl")

using Discord

using JSON
function prettyprint(thing::Any)::String
    buffer = IOBuffer();
    JSON.print(buffer, thing, 2)
    return String(take!(buffer))
end

Maybe{T} = Union{Some{T}, Nothing}


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

function main(secret=ENV["DISCORD_BOT_SECRET"])
    general::Maybe{Int64} = nothing
    of_interest::Maybe{Int64} = nothing

    c = Client(
        secret;
        presence=(game=(name="hello world", type=AT_GAME),)
    )

    function handler(c::Client, e::MessageCreate)
        msg = e.message
        bot_user = me(c)
        if bot_user.id == msg.author.id
            @info "ignoring message '$(e.message.content)' because it's from me"
            return
        end

        action = Lex.PostText(msg.content, string(msg.author.id))

        take_action(c, msg, action)
    end

    # add the message handler, open and wait
    add_handler!(c, MessageCreate, handler)
    open(c)
    wait(c)
end

end

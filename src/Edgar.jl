"""
This module is the application's entry point. It is responsible for connecting
to discord and routing messages through handlers.
"""
module Edgar

using Discord

include("./Types.jl")
include("./Actions.jl")
include("./Interactive.jl")


"""
Start the discord bot using the provided bot secret from the developer portal.
The secret can be provided as an argument to `main()` or it can come from the
`DISCORD_BOT_SECRET` environment variable.

Example usage:

    > julia --project=. -e 'using Edgar; Edgar.main()'

"""
function main(secret=ENV["DISCORD_BOT_SECRET"])
    client = Client(secret; presence=(game=(name="λ(x) = x", type=AT_GAME),))

    add_handler!(client, MessageCreate, on_message_create)

    open(client)
    wait(client)
end

"""
This function is invoked any time that a message is created in a server which
uses this bot.
"""
function on_message_create(client::Client, e::MessageCreate)
    if from_self(client, e.message) return end

    action = Interactive.handle(e.message.content, string(e.message.author.id))

    take_action(client, e.message, action)
end

"Evaluates to TRUE when the message was sent by this bot."
function from_self(client::Client, message::Message)::Bool
    bot_user = Discord.me(client)
    result = bot_user.id == message.author.id
    @debug """
    Message '$(message.content)'
    Is $(result ? "from" : "not from") this bot.
    """
    result
end

end

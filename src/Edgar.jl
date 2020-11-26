module Edgar

  using Discord

  Maybe{T} = Union{Some{T}, Nothing}

  function main(secret=ENV["DISCORD_BOT_SECRET"])
    general::Maybe{Int64} = nothing
    of_interest::Maybe{Int64} = nothing

    c = Client(
      secret;
      presence=(game=(name="hello world", type=AT_GAME),)
    )

    function take_interest(message::Message)
      @info """
      taking interest in
      $(message.content)
      with ids $(message.channel_id) - $(message.id)
      """

      of_interest = Some(message.id)
      general = Some(message.channel_id)
    end

    function add_to_interesting_message(line::AbstractString)
      @info "add '$line' to interesting message"
      actual_message =
        get_channel_message(c, something(general), something(of_interest)) |>
        fetchval

      new_content = "$(actual_message.content) \n - $(line)"
      @info "set '$new_content' in message"

      update(c, actual_message; content=new_content)
    end

    function generate_state_message(channel_id::UInt64)::Message
      create_message(c, channel_id; content="*Recurring Update*") |> fetchval
    end

    function handler(c::Client, e::MessageCreate)
      bot_user = me(c)
      if bot_user.id == e.message.author.id
        @info "ignoring message '$(e.message.content)' because it's from me"
        return
      end

      if startswith(e.message.content |> uppercase, "!EDGAR")
        generate_state_message(e.message.channel_id) |> take_interest
      elseif of_interest !== nothing
        add_to_interesting_message(e.message.content)
      else
        @info "'$e' was not very interesting"
      end
    end

    # add the message handler, open and wait
    add_handler!(c, MessageCreate, handler)
    open(c)
    wait(c)
  end
end

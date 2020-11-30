export Intent
export Help
export NothingIntent
export CreateTrial

"""
In general intents are an arbitrary string. But for this specific application
there are a finite set of Intents and it's convenient to represent them as an
enum.
NOTE the names here must literally match the names shown in the Lex dashboard.
"""
abstract type Intent end

"""
The Edgar Lex bot uses the 'Help' intent when replying to questions like
"help", and "what can you do".
"""
struct Help <: Intent end

"""
The Edgar Lex bot uses the 'NothingIntent' to quickly exit a conversation.
The user can trigger this with phrases like "nevermind", and "forget it".
"""
struct NothingIntent <: Intent end

"""
The Edgar Lex bot uses the 'CreateTrial' to schedule a new trial.
The conversation for this intent requires the user to give values for the
date, time, and trial title slots.
"""
struct CreateTrial <: Intent end

const IntentNames = Dict{String, Intent}(
    "CreateTrial" => CreateTrial(),
    "Help" => Help(),
    "Nothing" => NothingIntent()
)

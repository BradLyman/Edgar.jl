export DialogState
export ElicitIntent
export ConfirmIntent
export ElicitSlot
export Fulfilled
export ReadyForFulfillment
export Failed

"""
The current state of the user interaction.
See https://docs.aws.amazon.com/lex/latest/dg/API_runtime_PostText.html#lex-runtime_PostText-response-dialogState
"""
abstract type DialogState end

"Lex assumes this state when it is unaware of the user's intent"
struct ElicitIntent <: DialogState end

"""
Lex assumes this state when attempting to confirm something from the user.
e.g. "blah blah blah, right?"
"""
struct ConfirmIntent <: DialogState end

"Lex assumes this state when asking the user for a slot value."
struct ElicitSlot <: DialogState end

"""
Lex assumes this state when a configured Lambda function has already fulfilled
the intent.
"""
struct Fulfilled <: DialogState end

"Lex assumes this state when the application must fulfill the intent."
struct ReadyForFulfillment <: DialogState end

"Lex assumes this state when it cannot continue after retrying."
struct Failed <: DialogState end

const DialogStateNames = Dict{String, DialogState}(
    "ElicitIntent" => ElicitIntent(),
    "ConfirmIntent" => ConfirmIntent(),
    "ElicitSlot" => ElicitSlot(),
    "Fulfilled" => Fulfilled(),
    "ReadyForFulfillment" => ReadyForFulfillment(),
    "Failed" => Failed()
)


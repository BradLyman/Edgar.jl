using Base: @kwdef

export BotAction
export NoAction
export Reply
export CreateTrialPost

abstract type BotAction end

struct NoAction <: BotAction end

@kwdef struct Reply <: BotAction
    content::AbstractString
end

@kwdef struct CreateTrialPost <: BotAction
    trialname::AbstractString
    trialtime::AbstractString
    trialdate::AbstractString
end

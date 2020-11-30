# Edgar.jl - Lambda

This directory is for aws resources for lambda functions used by Edgar.

## input_processor

Edgar allows users to specify any name they'd like for a trial. Typically
there's an interaction like:-

> What should I call the trial?
> ...
> vSS - Second Boss Prog Run

These interactions are effectively impossible to train into an NLU model
because the name is an arbitrary phrase with arbitrary punctuation. This means
either have Lex make a bad guess about trial names, OR use a workaround to
support arbitrary strings.

This project takes the latter approach.

When filling a slot which should hold a complete phrase as-is, the
`input_processor` will override whatever analysis Lex attempts to do and fill
the slot with their literal statement.


using Edgar
using Documenter

makedocs(;
    modules=[Edgar],
    authors="Bradley Lyman <lyman.brad3211@gmail.com> and contributors",
    repo="https://github.com/BradLyman/Edgar.jl/blob/{commit}{path}#L{line}",
    sitename="Edgar.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://BradLyman.github.io/Edgar.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/BradLyman/Edgar.jl",
    devbranch="main"
)

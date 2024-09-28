using GershgorinDiscs
using Documenter

DocMeta.setdocmeta!(GershgorinDiscs, :DocTestSetup, :(using GershgorinDiscs); recursive=true)

makedocs(;
    modules=[GershgorinDiscs],
    authors="singularitti <singularitti@outlook.com> and contributors",
    sitename="GershgorinDiscs.jl",
    format=Documenter.HTML(;
        canonical="https://singularitti.github.io/GershgorinDiscs.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/singularitti/GershgorinDiscs.jl",
    devbranch="main",
)

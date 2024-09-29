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
        "Manual" => [
            "Installation Guide" => "man/installation.md",
            # "Definitions and conventions" => "man/definitions.md",
            # "Examples" => "man/examples.md",
            "Troubleshooting" => "man/troubleshooting.md",
        ],
        "Reference" => Any[
            "Public API" => "lib/public.md",
            # "Internals" => map(
            #     s -> "lib/internals/$(s)",
            #     sort(readdir(joinpath(@__DIR__, "src/lib/internals")))
            # ),
        ],
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style-guide.md",
            "Design Principles" => "developers/design-principles.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/singularitti/GershgorinDiscs.jl",
    devbranch="main",
)

using GershgorinDiscs
using Test

@testset "GershgorinDiscs.jl" begin
    # Write your tests here.
    include("constructors.jl")
    include("list_discs.jl")
    include("eigvals_extrema.jl")
end

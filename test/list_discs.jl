using LinearAlgebra: diagm

@testset "Test with non-square matrices" begin
    @test_throws DimensionMismatch list_discs(rand(3, 4))
    @test_throws DimensionMismatch list_discs(rand(4, 3))
end

@testset "Test on diagonal matrix" begin
    # For a diagonal matrix, the Gershgorin discs coincide with the spectrum.
    A = diagm(1:10)
    @test list_discs(A) == [Disc(λ, 0) for λ in eigvals(A)]
end

@testset "Test transpose" begin
    A = rand(10, 10)
    @test list_discs(A) == list_discs(transpose(A))
end

@testset "Example from Wikipedia" begin
    # See https://en.wikipedia.org/wiki/Gershgorin_circle_theorem#Example
    A = [
        10 1 0 1
        0.2 8 0.2 0.2
        1 1 2 1
        -1 -1 -1 -11
    ]
    @test all(
        list_discs(A) .≈
        [Disc((10, 0), 2), Disc((8, 0), 0.6), Disc((2, 0), 1.2), Disc((-11, 0), 2.2)],
    )
end

@testset "Test matrices with all negative eigenvalues and small Gershgorin disk radii" begin
    A = [
        -3 0.1
        0.05 -2.5
    ]
    @test eigvals(A) == [-3.0098076211353315, -2.4901923788646685]
    @test list_discs(A) ==
        [Disc(-3.0, 0.04999999999999982), Disc(-2.5, 0.04999999999999982)]
    @test all(eigvals(A) .∈ list_discs(A))
end

@testset "Test matrices with all positive eigenvalues and small Gershgorin disk radii" begin
    A = [
        2 0.1
        0.05 1.5
    ]
    @test eigvals(A) == [1.4901923788646685, 2.0098076211353315]
    @test list_discs(A) ==
        [GershgorinDisc(2, 0.04999999999999982), Disc(1.5, 0.050000000000000044)]
    @test eigvals(A)[1] in list_discs(A)[2]
end

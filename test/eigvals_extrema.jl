@testset "Example from Wikipedia" begin
    # See https://en.wikipedia.org/wiki/Gershgorin_circle_theorem#Example
    A = [
        10 1 0 1
        0.2 8 0.2 0.2
        1 1 2 1
        -1 -1 -1 -11
    ]
    @test eigvals(A) ==
        [-10.869923641698216, 1.9063276022174214, 7.917541527665002, 10.046054511815802]
    @test eigvals_extrema(A) == (-13.2, 12.0)
    @test minimum(eigvals(A)) >= minimum(eigvals_extrema(A))
    @test maximum(eigvals(A)) <= maximum(eigvals_extrema(A))
end

@testset "Test matrices with all negative eigenvalues and small Gershgorin disk radii" begin
    A = [
        -3 0.1
        0.05 -2.5
    ]
    @test eigvals(A) == [-3.0098076211353315, -2.4901923788646685]
    @test eigvals_extrema(A) == (-3.05, -2.45)
    @test minimum(eigvals(A)) >= minimum(eigvals_extrema(A))
    @test maximum(eigvals(A)) <= maximum(eigvals_extrema(A))
end

@testset "Test matrices with all positive eigenvalues and small Gershgorin disk radii" begin
    A = [
        2 0.1
        0.05 1.5
    ]
    @test eigvals(A) == [1.4901923788646685, 2.0098076211353315]
    @test eigvals_extrema(A) == (1.45, 2.05)
    @test minimum(eigvals(A)) >= minimum(eigvals_extrema(A))
    @test maximum(eigvals(A)) <= maximum(eigvals_extrema(A))
end

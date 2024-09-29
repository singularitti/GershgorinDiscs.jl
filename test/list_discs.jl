@testset "Example from Wikipedia" begin
    # See https://en.wikipedia.org/wiki/Gershgorin_circle_theorem#Example
    A = [
        10 1 0 1
        0.2 8 0.2 0.2
        1 1 2 1
        -1 -1 -1 -11
    ]
    @test all(list_discs(A) .≈ [Disc(10, 2), Disc(8, 0.6), Disc(2, 1.2), Disc(-11, 2.2)])
end

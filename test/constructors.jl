@testset "Test type conversion in `GershgorinDisc` constructors" begin
    @test GershgorinDisc(1.0, 2) == GershgorinDisc((1.0, 0.0), 2.0)
    @test GershgorinDisc(1, 2.1) == GershgorinDisc((1.0, 0.0), 2.1)
    @test GershgorinDisc(1.0 + 2.0im, 2) == GershgorinDisc((1.0, 2.0), 2.0)
    @test GershgorinDisc(1 + 2im, 2.1) == GershgorinDisc((1.0, 2.0), 2.1)
end

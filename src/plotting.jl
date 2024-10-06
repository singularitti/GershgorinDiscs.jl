using RecipesBase: @recipe, @series

function circle(x₀, y₀, r)
    𝛉 = range(0, 2π; length=500)
    return x₀ .+ r * sin.(𝛉), y₀ .+ r * cos.(𝛉)
end

# See https://discourse.julialang.org/t/23295/6
@recipe function f(disc::GershgorinDisc)
    center, radius = disc.center, disc.radius
    x₀, y₀ = center
    𝐱, 𝐲 = circle(x₀, y₀, radius)
    @series begin
        seriestype --> :scatter
        primary := false
        seriesalpha --> 1
        markercolor --> :black  # Black border for the center
        [x₀], [y₀]
    end
    seriestype --> :shape
    seriesalpha --> 0
    fillalpha --> 0.5
    aspect_ratio --> :equal
    return 𝐱, 𝐲
end

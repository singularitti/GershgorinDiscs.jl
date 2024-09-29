using RecipesBase: @recipe

function circle(x₀, y₀, r)
    𝛉 = range(0, 2π; length=500)
    return x₀ .+ r * sin.(𝛉), y₀ .+ r * cos.(𝛉)
end

# See https://discourse.julialang.org/t/23295/6
@recipe function f(disc::GershgorinDisc)
    center, radius = disc.center, disc.radius
    x₀, y₀ = center
    𝐱, 𝐲 = circle(x₀, y₀, radius)
    seriestype --> :shape
    aspect_ratio --> :equal
    fillalpha --> 0.5
    return 𝐱, 𝐲
end

module GershgorinDiscs

using LinearAlgebra: diag, checksquare

export GershgorinDisc, Disc, list_discs, eigvals_extrema

struct GershgorinDisc{T}
    center::NTuple{2,T}
    radius::T
    function GershgorinDisc(center::NTuple{2,S}, radius::R) where {S,R}
        T = promote_type(S, R)
        return new{T}(center, convert(T, radius))
    end
end
GershgorinDisc(x::Number, radius) = GershgorinDisc((x, zero(x)), radius)
GershgorinDisc(center::Complex{T}, radius) where {T} = GershgorinDisc(reim(center), radius)
const Disc = GershgorinDisc

function list_discs(A::AbstractMatrix)
    checksquare(A)  # See https://discourse.julialang.org/t/120556/2
    centers = diag(A)
    row_discs = map(zip(eachrow(A), centers)) do (row, center)
        radius = sum(abs, row) - abs(center)
        GershgorinDisc(center, radius)
    end
    col_discs = map(zip(eachcol(A), centers)) do (col, center)
        radius = sum(abs, col) - abs(center)
        GershgorinDisc(center, radius)
    end
    return vcat(row_discs, col_discs)
end

function eigvals_extrema(A::AbstractMatrix)
    λₘᵢₙ, λₘₐₓ = zero(eltype(A)), zero(eltype(A))
    discs = list_discs(A)
    for disc in discs
        center, radius = disc.center, disc.radius
        x, _ = center
        left, right = x - radius, x + radius
        if left < λₘᵢₙ
            λₘᵢₙ = left
        elseif right > λₘₐₓ
            λₘₐₓ = right
        end
    end
    return λₘᵢₙ, λₘₐₓ
end

include("plotting.jl")

end

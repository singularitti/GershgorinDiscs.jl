module GershgorinDiscs

using LinearAlgebra: diag, checksquare

export GershgorinDisc, Disc, list_discs, eigvals_extrema

struct GershgorinDisc{T}
    center::T
    radius::T
end
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
    centers = diag(A)
    for (row, center) in zip(eachrow(A), centers)
        radius = sum(abs, row) - abs(center)
        left, right = center - radius, center + radius
        if left < λₘᵢₙ
            λₘᵢₙ = left
        elseif right > λₘₐₓ
            λₘₐₓ = right
        end
    end
    return λₘᵢₙ, λₘₐₓ
end

end

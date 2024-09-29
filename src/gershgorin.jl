using LinearAlgebra: diag, checksquare
using SplitApplyCombine: group

export GershgorinDisc, Disc, is_center_real, list_discs, eigvals_extrema

struct GershgorinDisc{T}
    center::NTuple{2,T}
    radius::T
    function GershgorinDisc(center::NTuple{2,S}, radius::R) where {S,R}
        if radius < zero(radius)
            throw(DomainError(radius, "radius must be non-negative!"))
        end
        T = promote_type(S, R)
        return new{T}(center, convert(T, radius))
    end
end
GershgorinDisc(x::Number, radius) = GershgorinDisc((x, zero(x)), radius)
GershgorinDisc(center::Complex{T}, radius) where {T} = GershgorinDisc(reim(center), radius)
const Disc = GershgorinDisc

is_center_real(d::GershgorinDisc{T}) where {T} = d.center[end] == zero(T)

"""
    list_discs(A::AbstractMatrix)

Compute the Gershgorin discs for a square matrix `A`, returning a list of discs where each center is unique and has the smallest associated radius.

This function calculates the discs based on both rows and columns. If multiple discs share the same center, the disc with the smallest radius is retained.

## Arguments

- `A::AbstractMatrix`: A square matrix (either real or complex).

## Returns

- A `Vector` of `GershgorinDisc` objects. Each disc corresponds to a unique center (diagonal element of the matrix `A`) with the smallest radius.

## Examples

```jldoctest
julia> A = [4.0 1.0; 0.5 3.0]
2×2 Matrix{Float64}:
 4.0  1.0
 0.5  3.0

julia> list_discs(A)
2-element Vector{GershgorinDisc{Float64}}:
 GershgorinDisc{Float64}((4.0, 0.0), 0.5)
 GershgorinDisc{Float64}((3.0, 0.0), 0.5)
"""
function list_discs(A::AbstractMatrix)
    checksquare(A)  # See https://discourse.julialang.org/t/120556/2
    # Extract diagonal elements to be used as centers for Gershgorin discs
    centers = diag(A)
    row_discs = map(zip(eachrow(A), centers)) do (row, center)  # Row-based Gershgorin discs
        radius = sum(abs, row) - abs(center)
        GershgorinDisc(center, radius)
    end
    col_discs = map(zip(eachcol(A), centers)) do (col, center)  # Column-based Gershgorin discs
        radius = sum(abs, col) - abs(center)
        GershgorinDisc(center, radius)
    end
    discs = vcat(row_discs, col_discs)  # Combine row and column discs into a single list
    groups = group(disc -> disc.center, discs)  # Group the discs by their center
    # For each group of discs with the same center, sort by radius and pick the smallest
    return collect(first(sort(group; by=disc -> disc.radius)) for group in groups)
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

Base.isapprox(a::GershgorinDisc, b::GershgorinDisc; kwargs...) =
    isapprox(collect(a.center), collect(b.center); kwargs...) &&
    isapprox(a.radius, b.radius; kwargs...)

Base.in(number, disc::GershgorinDisc) =
    abs(complex(number) - complex(disc.center...)) <= disc.radius
function Base.in(a::GershgorinDisc, b::GershgorinDisc)
    # The radius of the smaller disk must be less than or equal to the radius of the larger disk.
    if a.radius > b.radius
        return false
    else
        # The distance between the centers of the two disks must be less than or equal to the difference between their radii.
        return abs(complex(a.center...) - complex(b.center...)) <= b.radius - a.radius
    end
end

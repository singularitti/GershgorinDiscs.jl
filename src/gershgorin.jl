using LinearAlgebra: diag, checksquare

export GershgorinDisc, Disc, is_center_real, is_concentric, list_discs, eigvals_extrema

"""
    GershgorinDisc{T}

Represent a Gershgorin disc in the complex plane associated with a matrix.

# Arguments
- `center`: a tuple `(real_part, imaginary_part)` representing the center of the disc.
- `radius`: a non-negative real number representing the radius of the disc.
"""
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
"""
    GershgorinDisc(x::Number, radius)

Construct a `GershgorinDisc` from a real or complex number and a radius.
"""
GershgorinDisc(x::Number, radius) = GershgorinDisc((x, zero(x)), radius)
GershgorinDisc(center::Complex{T}, radius) where {T} = GershgorinDisc(reim(center), radius)
"A alias to `GershgorinDisc`."
const Disc = GershgorinDisc

"""
    is_center_real(d::GershgorinDisc)

Check whether the center of the given `GershgorinDisc` is real.
"""
is_center_real(d::GershgorinDisc{T}) where {T} = d.center[end] == zero(T)

"""
    is_concentric(a::GershgorinDisc, b::GershgorinDisc)

Check whether two `GershgorinDisc` objects are concentric.
"""
is_concentric(a::GershgorinDisc, b::GershgorinDisc) = a.center == b.center

"""
    list_discs(A::AbstractMatrix)

Compute the Gershgorin discs for a square matrix.

Each disc has its center at a diagonal element, and its radius is the smaller value between the row and column sums for that element.

# Arguments
- `A::AbstractMatrix`: a square matrix (either real or complex).

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
```
"""
function list_discs(A::AbstractMatrix)
    checksquare(A)  # See https://discourse.julialang.org/t/120556/2
    # Extract diagonal elements to be used as centers for Gershgorin discs
    centers = diag(A)
    # It's a square matrix, so we can iterate over rows and columns simultaneously.
    return map(zip(eachrow(A), eachcol(A), centers)) do (row, col, center)
        row_radius = sum(abs, row) - abs(center)
        col_radius = sum(abs, col) - abs(center)
        GershgorinDisc(center, minimum((row_radius, col_radius)))
    end
end

"""
    eigvals_extrema(A::AbstractMatrix)

Estimate the minimum and maximum eigenvalues of a square matrix `A` using Gershgorin circle theorem.

This function computes the Gershgorin discs for `A` and returns the smallest and largest values
that any eigenvalue could have based on the discs.
"""
function eigvals_extrema(A::AbstractMatrix)
    λₘᵢₙ, λₘₐₓ = Inf * oneunit(eltype(A)), -Inf * oneunit(eltype(A))
    discs = list_discs(A)
    for disc in discs
        if !is_center_real(disc)
            @warn "The center of the disc is not real, which may lead to inaccurate results."
        end
        center, radius = disc.center, disc.radius
        x, _ = center
        left, right = x - radius, x + radius
        if left < λₘᵢₙ
            λₘᵢₙ = left
        end
        if right > λₘₐₓ
            λₘₐₓ = right
        end
    end
    return λₘᵢₙ, λₘₐₓ
end

"""
    isapprox(a::GershgorinDisc, b::GershgorinDisc; kwargs...)

Check if two `GershgorinDisc` objects are approximately equal.
"""
Base.isapprox(a::GershgorinDisc, b::GershgorinDisc; kwargs...) =
    isapprox(collect(a.center), collect(b.center); kwargs...) &&
    isapprox(a.radius, b.radius; kwargs...)

Base.:(==)(a::GershgorinDisc, b::GershgorinDisc) =
    a.center == b.center && a.radius == b.radius

"""
    in(number, disc::GershgorinDisc)

Check if a number is within the Gershgorin disc.
"""
Base.in(number, disc::GershgorinDisc) =
    abs(complex(number) - complex(disc.center...)) <= disc.radius
"""
    in(a::GershgorinDisc, b::GershgorinDisc)

Check if one Gershgorin disc is within another Gershgorin disc.
"""
function Base.in(a::GershgorinDisc, b::GershgorinDisc)
    # The radius of the smaller disk must be less than or equal to the radius of the larger disk.
    if a.radius > b.radius
        return false
    else
        # The distance between the centers of the two disks must be less than or equal to the difference between their radii.
        return abs(complex(a.center...) - complex(b.center...)) <= b.radius - a.radius
    end
end

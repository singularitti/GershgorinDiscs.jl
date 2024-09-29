module GershgorinDiscs

using LinearAlgebra: diag

export gershgorin_extrema

function gershgorin_extrema(A::AbstractMatrix)
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

export Grid, Particles, Sample
export gridData


struct GridGeometry
    xmin
    xmax
    ymin
    ymax
    Nx::Int64
    Ny::Int64
    dx
    dy
end


mutable struct Particles
    x
    y
end
initialiseParticles() = Particles([], [])


struct Sample
    grid::GridGeometry
    particles::Particles
end


mutable struct GridData
    gridGeom::GridGeometry
    xref
    yref
    x::Vector{Float64}
    y::Vector{Float64}
    data::Dict
end
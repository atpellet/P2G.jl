# --- Exports ---
export createParticleSet
export Grid, Particles, Sample
export plotSample


# --- Structures ---

struct GridCoordinates
    x
    y
end

mutable struct Particles
    x
    y
end

struct Sample
    grid::GridCoordinates
    particles::Particles
end

initialiseParticles() = Particles([], [])


# --- Functions ---

# Sampling

function sampleParticle(xmin, ymin, dx, dy)
    px = (xmin + dx/4) + (-0.5 + rand()) * dx/4
    py = (ymin + dy/4) + (-0.5 + rand()) * dy/4 
    return [px, py]
end

function sampleInCell!(refparticles::Base.RefValue{Particles}, xm, ym, dx, dy)
    # Note : only 4 particles per cell supported for now
    xmins = [xm, xm + dx/2]
    ymins = [ym, ym + dy/2]
    for i in 1:2
        for j in 1:2
            sampleOfParticles = sampleParticle(xmins[i], ymins[j], dx, dy)
            append!(refparticles.x.x, sampleOfParticles[1])
            append!(refparticles.x.y, sampleOfParticles[2])
        end
    end
end


function createParticleSet(xmin, xmax, ymin, ymax, dX)
    # adapting dx and dy to get uniform cell sizes 
    Nx = div((xmax-xmin), dX, RoundUp)
    Ny = div((ymax-ymin), dX, RoundUp)
    dx = (xmax-xmin)/Nx
    dy = (ymax-ymin)/Ny
    if dx != dX || dy != dX 
        println("Cell size adapted to match sample dimensions with uniform grid")
        println("New cell dimensions are :")
        println("                           dx = ", dx)
        println("                           dy = ", dy)
    end
    # create the grid
    grid = Grid(collect(xmin:dx:xmax), collect(ymin:dy:ymax))
    particles = initialiseParticles()
    # sample the particles onto the grid
    #sampleInCell!.(Ref(particles), grid.x[1:end-1], grid.y[1:end-1], Ref(dx), Ref(dy), Ref(ppc))
    for i in 1:Nx
        for j in 1:Ny
            println("(i,j) = (", i, ",", j, ")")
            println("grid (x,y) = (", grid.x[i], ",", grid.y[j], ")")
            sampleInCell!(Ref(particles), grid.x[i], grid.y[j], dx, dy)
        end
    end    
    # end
    println(length(particles.x), " particles created")
    return Sample(grid, particles)
end



# Traces

function traceSampleParticles(particles::Particles)
    trace = scatter(x=particles.x, y=particles.y, mode=:markers, marker_color=:blue, showlegend=false)
    return trace
end


function traceSampleGrid(grid::GridCoordinates)
    traces = []
    traces = convert(Vector{typeof(scatter())}, traces)
    xmin = minimum(grid.x)
    xmax = maximum(grid.x)
    ymin = minimum(grid.y)
    ymax = maximum(grid.y)
    for i in 1:length(grid.x)
        xpos = grid.x[i]
        trace = scatter(x=[xpos, xpos], y=[ymin, ymax])
        append!(traces, [trace])
    end
    for i in 1:length(grid.y)
        ypos = grid.y[i]
        trace = scatter(x=[xmin, xmax], y=[ypos, ypos])
        append!(traces, [trace])
    end
    for trace in traces
        trace.line_color=:black
        trace.showlegend=false
        trace.mode=:lines
    end
    return traces
end



# Ploter

function plotSample end

function plotSample(;traceGrid::Union{Vector{typeof(scatter())}, Nothing}=nothing, traceParticles::Union{typeof(scatter()),Nothing}=nothing) 
    traces = []
    traces = convert(Vector{typeof(scatter())}, traces)
    if traceGrid !isnothing
        append!(traces, traceGrid)
    end
    if traceParticles !isnothing
        append!(traces, [traceParticles])
    end
    plot(traces)
end 

function plotSample(sampleSet::Sample)
    tGrid = traceSampleGrid(sampleSet.grid)
    tParticles = traceSampleParticles(sampleSet.particles)
    plotSample(;traceGrid=tGrid, traceParticles=tParticles)
end

plotSample(grid::GridCoordinates) = plotSample(;traceGrid=traceSampleGrid(grid))

plotSample(particles::Particles) = plotSample(;traceParticles=traceSampleParticles(particles))

plotSample(traceGrid::Vector{typeof(scatter())}) = plotSample(;traceGrid=traceGrid)

plotSample(traceParticles::typeof(scatter())) = plotSample(;traceParticles=traceParticles)
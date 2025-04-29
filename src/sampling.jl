# --- Exports ---
export createParticleSet, createGrid
export plotSample

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

function createGrid(xmin, xmax, ymin, ymax, dX; verbose::Bool=false)
    # adapting dx and dy to get uniform cell sizes 
    Nx = div((xmax-xmin), dX, RoundUp)
    Ny = div((ymax-ymin), dX, RoundUp)
    dx = (xmax-xmin)/Nx
    dy = (ymax-ymin)/Ny
    if (dx != dX || dy != dX) && verbose
        println("Cell size adapted to match sample dimensions with uniform grid")
        println("New cell dimensions are :")
        println("                           dx = ", dx)
        println("                           dy = ", dy)
    end
    return GridGeometry(xmin, xmax, ymin, ymax, Nx, Ny, dx, dy)
end

function createParticleSet end

function createParticleSet(grid::GridGeometry)
    particles = initialiseParticles()
    # sample the particles onto the grid
    #sampleInCell!.(Ref(particles), grid.x[1:end-1], grid.y[1:end-1], Ref(dx), Ref(dy), Ref(ppc))
    for i in 0:grid.Nx-1
        for j in 0:grid.Ny-1
            sampleInCell!(Ref(particles), grid.xmin+i*grid.dx, grid.ymin+j*grid.dy, grid.dx, grid.dy)
        end
    end    
    # end
    println(length(particles.x), " particles created")
    return Sample(grid, particles)
end

function createParticleSet(xmin, xmax, ymin, ymax, dX)
    # create the grid
    grid = createGrid(xmin, xmax, ymin, ymax, dX)
    createParticleSet(grid)
end



# Traces

function traceSampleParticles(particles::Particles)
    trace = scatter(x=particles.x, y=particles.y,
                    mode=:markers,
                    marker_color=:blue,
                    showlegend=false)
    return trace
end


function traceSampleGrid(grid::GridGeometry)
    traces = []
    traces = convert(Vector{typeof(scatter())}, traces)
    for i in 0:grid.Nx
        xpos = grid.xmin+i * grid.dx
        trace = scatter(x=[xpos, xpos], y=[grid.ymin, grid.ymax])
        append!(traces, [trace])
    end
    for j in 0:grid.Ny
        ypos = grid.ymin + j * grid.dy
        trace = scatter(x=[grid.xmin, grid.xmax], y=[ypos, ypos])
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
    if traceGrid != nothing
        append!(traces, traceGrid)
    end
    if traceParticles != nothing
        append!(traces, [traceParticles])
    end
    layout = Layout(yaxis_scaleanchor="x")
    plot(traces, layout)
end 

function plotSample(sampleSet::Sample)
    tGrid = traceSampleGrid(sampleSet.grid)
    tParticles = traceSampleParticles(sampleSet.particles)
    plotSample(;traceGrid=tGrid, traceParticles=tParticles)
end

plotSample(grid::GridGeometry) = plotSample(;traceGrid=traceSampleGrid(grid))

plotSample(particles::Particles) = plotSample(;traceParticles=traceSampleParticles(particles))

plotSample(traceGrid::Vector{typeof(scatter())}) = plotSample(;traceGrid=traceGrid)

plotSample(traceParticles::typeof(scatter())) = plotSample(;traceParticles=traceParticles)
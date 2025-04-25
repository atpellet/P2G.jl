# --- Exports ---
export createParticleSet


# --- Structures ---

struct Grid
    x
    y
end

mutable struct Particles
    x
    y
end

initialiseParticles() = Particles([], [])


# --- Functions ---

function sampleParticle(xmin, ymin, dx, dy)
    px = (xmin + dx/2) * (0.75 + rand()/2)
    py = (ymin + dy/2) * (0.75 + rand()/2)
    return [px, py]
end

function sampleInCell!(particles::Particles, xm, ym, dx, dy, ppc::Int)
    if ppc != 4
        println("WARNING : only 4 particles per cell supported for now, ppc forced to 4")
        ppc = 4
    end
    xmins = [xm, xm + dx]
    ymins = [ym, ym + dy]
    sampleOfParticles = sampleParticle.(xmins, ymins, Ref(dx), Ref(dy))
    append!(particles.x, sampleOfParticles[1])
    append!(particles.y, sampleOfParticles[2])
    return sampleOfParticles
end


function createParticleSet(xmin, xmax, ymin, ymax, dX; ppc=4)
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
    sampleInCell!.(Ref(particles), grid.x[1:end-1], grid.y[1:end-1], Ref(dx), Ref(dy), Ref(ppc))
    # end
    println(length(particles.x), " particles created")
    return particles, grid
end
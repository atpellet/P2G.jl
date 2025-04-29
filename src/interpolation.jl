# TODO EFFICIENCY IMPROVEMENT : Replace recurent divisions by precalculated products
# --> Ex : ()/dx -> ()*one_over_dx
# --> A struct should contain these precalculations

# TODO PRECISION IMPROVEMENT ?
# ??? Sould I add border specific interpolation functions ?
# --> On on hand it should add precision and scheme stability on the borders, (opt 1)
# but on the other hand expanding the borders further than the sample limit does it (opt 2)
# --> Option 1 : adding "if" statement everytime slows the program
# --> Option 2 : expanding sample limits add more memory space usage

# --- Exports ---
export initialiseGridData
export createGridDataFromSample
export p2g!

# --- Functions ---

# Initialising Grid nodes where the data will be interpolated

function initialiseGridData end

#= DEPRECATED
function initialiseGridData(grid::GridGeometry)
    n = (grid.Nx+1) * (grid.Ny+1)
    xi = Vector(undef, n)
    yi = Vector(undef, n)
    di = Dict()
    # Fill in x and y values
    count = 0
    for i in 1:grid.Nx+1
        for j in 1:grid.Ny+1
            count += 1
            xi[count] = grid.xmin + (i-1) * grid.dx
            yi[count] = grid.ymin + (j-1) * grid.dy
        end
    end
    return GridData(grid, xi[1], yi[1], xi, yi, di)
end
=#

function initialiseGridData(grid::GridGeometry)
    xi = Vector(undef, grid.Nx+1)
    yi = Vector(undef, grid.Ny+1)
    di = Dict()
    # Fill in x and y values
    for i in 1:grid.Nx+1
        for j in 1:grid.Ny+1
            xi[i] = grid.xmin + (i-1) * grid.dx
            yi[j] = grid.ymin + (j-1) * grid.dy
        end
    end
    return GridData(grid, xi[1], yi[1], xi, yi, di)
    # QUESTION : is calling grid.xmin slower than...
    # ... creating xmin = grid.xmin outside for loop and then calling xmin ?
end

initialiseGridData(xmin, xmax, ymin, ymax, dX) = initialiseGridData(createGrid(xmin, xmax, ymin, ymax, dX))


# Creating gridData from sample Particles

function createGridDataFromSample end

function createGridDataFromSample(sample::PlyElement, dX::Any)
    if !( length(sample["x"]) == length(sample["y"]) )
        error_message =
        """
        x and y must have the same length : n, n 
        Current dimensions are : $(length(x)), $(length(y))
        """
        throw(DimensionMismatch(error_message))
    end
    xmin, xmax = extrema(sample["x"])
    ymin, ymax = extrema(sample["y"])
    return initialiseGridData(xmin-3*dX, xmax+3*dX, ymin-3*dX, ymax+3*dX, dX)
end

#=
function createGridDataFromSample(sample::DataFrame, dX)
    # TODO Write method for sample as DataFrame and/or sample from .csv or .txt file
end
=#


# Interpolation functions
function N end
# TODO EFFICIENCY IMPROVEMENT : set the N function once at the beginning.
# --> Avoid "if" evaluation for every particle 
# --> Could be done in an "initialisingAnalysis"-type function

function N(u, method::Symbol)
    uabs = abs(u)
    if method == :quad_Bsp # Quadratic B-spline
        if uabs < 0.5
            return 0.75 - uabs^2
        elseif uabs < 1.5
            return 0.5*(1.5-uabs^2)
        else
            return 0
        end 
    elseif method == :cubic_Bsp # Cubinc B-spline
        if uabs < 1
            0.5*uabs^3 - uabs^2 + 2/3
        elseif uabs < 2
            -(1/6)*uabs^3 + uabs^2 + 2*uabs + 0.75
        else
            return 0
        end
    elseif method == :lin_hat # Linear hat
        if uabs < 1
            return 1-uabs
        else 
            return 0
        end
    else # Set to default (quadratic B spline) with a warning
        println("WARNING   Wrong method argument passed. Set to default : quadratic B-spline")
        return N(u, :quad_Bsp) # 1 level recursivity
    end
end

function N(u)
    println("   INFO   No interpolation method passed, default is set to quadratic B-spline")
    return N(u, :quad_Bsp)
end

#=
function N(u, method=:quad_Bsp)
    return N(u, :quad_Bsp)
end
=#


# Particle-to-Grid
function p2g end 

function p2g!(gData::GridData, x, y, d, qty::Symbol; Nmode=:quad_Bsp)
    # Primary function assuming gData was created in accordance with x and y
    if !( length(x) == length(y) == length(d) )
        error_message =
        """
        x, y, d must all have the same length
        Current dimensions are : $(length(x)), $(length(y)), $(length(d))
        """
        throw(DimensionMismatch(error_message))
    end
    # Initialise data entry
    gData.data[qty] = zeros(length(gData.x), length(gData.x))
    # Some precalculations
    one_over_dx = 1 / gData.gridGeom.dx
    one_over_dy = 1 / gData.gridGeom.dy 
    # Loop over all particles
    for p in eachindex(x)
        # Neighbour grid nodes search
        i_base = floor(Int64, (x[p] - gData.xref) * one_over_dx )
        j_base = floor(Int64, (y[p] - gData.yref) * one_over_dy )
        # Loop over the neighbour grid nodes
        for i in i_base:i_base+3
            for j in j_base:j_base+3
                # add weighted particle's data value
                #println(x[p] - gData.x[i])
                weight = N((x[p] - gData.x[i]) * one_over_dx, Nmode) * N((y[p] - gData.y[j]) * one_over_dy, Nmode)
                gData.data[qty][i,j] += weight * d[p]
                # TODO Add a count/verification of particles per cell
                # --> Set as missing the cells/nodes for which too few points a present
            end
        end
    end
end
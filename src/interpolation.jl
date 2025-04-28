# --- Exports ---
export initialiseGridData
export gridData

# --- Structures ---

mutable struct GridData
    x::Vector{Float64}
    y::Vector{Float64}
    data::Dict
end


# --- Functions ---

function initialiseGridData(grid::Grid)
    n = (grid.Nx+1) * (grid.Ny+1)
    xi = Vector{Float64}(undef, n)
    yi = Vector{Float64}(undef, n)
    di = Dict()
    # Fill in x and y values
    count = 0
    for i in 1:grid.Nx+1
        for j in 1:grid.Ny+1
            count += 1
            xi[count] = grid.xmin + (i-1) * grid.dx
            yi[count] = grid.ymin + (j-1) * grid.dy
            # @printf("(i,j) = (%i, %i) -- and -- (x,y) = (%i, %i)\n", i, j, xi[count], yi[count])
        end
    end
    return GridData(xi, yi, di)
end

#=
Steps :
1. Open data as Dataframe
2. Interpolating data from nodes to grid points
    --> grid data shall be represented as three vectors : x, y, data
3. Ploting grid data as heatmap

=#
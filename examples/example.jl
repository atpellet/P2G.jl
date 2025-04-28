
using P2G
using PlotlyJS

#=
grid = createGrid(0, 2, 0, 4, 1)

data = initialiseGridData(grid)

traces_grid = P2G.traceSampleGrid(grid)
trace_griddata = scatter(x=data.x, y=data.y, mode=:markers, marker_color=:red)
layout = Layout(yaxis_scaleanchor=:x)
plot(vcat(traces_grid, trace_griddata), layout)
=#

dummyset = createParticleSet(0, 2, 0, 4, 1)
plotSample(dummyset)

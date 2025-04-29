
using P2G
using PlotlyJS
using PlyIO

#=
grid = createGrid(0, 2, 0, 4, 1)

data = initialiseGridData(grid)

traces_grid = P2G.traceSampleGrid(grid)
trace_griddata = scatter(x=data.x, y=data.y, mode=:markers, marker_color=:red)
layout = Layout(yaxis_scaleanchor=:x)
plot(vcat(traces_grid, trace_griddata), layout)
=#


#frame = 16
frame += 1
file_path = "/home/pelletal/matter/pellet_branch/build/output/IsotropicCompression/particles_f$frame.ply"
sample = load_ply(file_path)["vertex"]

data = createGridDataFromSample(sample, 0.02)
p2g!(data, sample["x"], sample["y"], sample["p"], :p)


trace = heatmap(z=data.data[:p], x=data.x, y=data.y)
layout = Layout(yaxis_scaleanchor=:x)

trace_grid = P2G.traceSampleGrid(data.gridGeom)
# plot([trace_grid; trace], layout)
plot(trace, layout)

# plot([scatter(x=sample["x"], y=sample["y"], mode=:markers); trace_grid],  Layout(yaxis_scaleanchor=:x))


using P2G

using PlotlyJS


dummyset = createParticleSet(0, 2, 0, 5, 1)

plotSample(dummyset)
#=
traceGrid=P2G.traceSampleGrid(dummyset.grid)
trace = scatter(x=dummyset.grid.x, y=dummyset.grid.y, marker_color=:red, mode=:markers, marker_size=10)
plot(vcat(traceGrid, trace))
=#
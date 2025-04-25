# P2G

[![Build Status](https://github.com/atpellet/P2G.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/atpellet/P2G.jl/actions/workflows/CI.yml?query=branch%3Amain)


# Presentation

This package aims at providing tools for post-processing unordered and unevenlly placed data points. It is originally designed to process outputs of Material Point Method (MPM) nmerical simulations. It interpolates the data from the material points to a background mesh, much like the particle-to-mesh step in MPM simulations. Thus, data can be represented on a smoothed mesh for better clarity.
As I don't feel the need for 3D (the purpose is to project complex data onto 2D plot...), only 2D representation is supported

!!! This package is at early stages, and in active developpement. It is ueless for now !!!

# Roadmap

1. Create background grid from points sample
2. Interpolate particles' data to grid (with basic interpolation scheme)
3. Implement empty info on grid points surounded by few or no particles (~ manage complicated shapes)
4. Implement main interpolation methods (linear, splines, ...)

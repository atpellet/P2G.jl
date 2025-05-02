# P2G - Postprocessing tools for MPM simulations


[![Build Status](https://github.com/atpellet/P2G.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/atpellet/P2G.jl/actions/workflows/CI.yml?query=branch%3Amain)


# Presentation

This package aims at providing tools for post-processing unordered and unevenlly placed data points. It is originally designed to process outputs of Material Point Method (MPM) numerical simulations. It interpolates the data from the material points to a background mesh, much like the particle-to-mesh step in MPM simulations. Thus, data can be represented on a smoothed mesh for better clarity.

Note : This package only supports 2D data representation.


# Roadmap

1. Implement empty info on grid points surounded by few or no particles (~ manage complicated shapes)

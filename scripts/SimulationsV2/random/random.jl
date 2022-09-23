# using Pkg
# Pkg.activate(".")
using Distributed
addprocs(5)
@everywhere using EvoDynamics
using JLD2
using FileIO
# using Agents
# using Distributions
# using Random
# using LinearAlgebra

param_file = "params.jl"
adata, mdata, models = runmodel(param_file, replicates=6, parallel=true)

save("output.jld2", "results", mdata)

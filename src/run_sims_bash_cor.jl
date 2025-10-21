using Pkg
Pkg.activate(".")
using EvoDynamics
using FileIO
using Agents
using Statistics

include("data_collection_functions.jl")

function run_simulation(f, paramdir, results_dir, nreplicates)
  param_file = joinpath(paramdir, f)

  adata, mdata, models = runmodel(param_file, replicates=nreplicates, adata=nothing, mdata=[EvoDynamics.mean_fitness_per_species, EvoDynamics.species_N, mean_espistasis_matrix_per_species], parallel=true, when_model=0:10:500, showprogress=true)

  save(joinpath(results_dir, "$(f[1:end-3]).jld2"), "results", mdata)
end

# Command line arguments
f = ARGS[1]
paramdir = ARGS[2]
results_dir = ARGS[3]
nreplicates = parse(Int, ARGS[4])

run_simulation(f, paramdir, results_dir, nreplicates)

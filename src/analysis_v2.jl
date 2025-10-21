using Pkg; Pkg.activate(".")
using FileIO
using ImageIO
using ImageMagick
using OpenCV
using DataFrames
using Statistics
using StatsBase
using JLD2
using VegaLite

correlated_sim_outputs_dir = "sim_outputs_correlated/"
modular_sim_outputs_dir = "sim_outputs_modular/"

# load the simulation outputs
# 1. load all the files in the correlated_sim_outputs_dir
correlated_sim_outputs = Dict()
for file in readdir(correlated_sim_outputs_dir)
  if endswith(file, ".jld2")
    sim_name = splitext(file)[1]
    correlated_sim_outputs[sim_name] = load(joinpath(correlated_sim_outputs_dir, file), "results")
  end
end

# 2. load all the files in the modular_sim_outputs_dir
modular_sim_outputs = Dict()
for file in readdir(modular_sim_outputs_dir)
  if endswith(file, ".jld2")
    sim_name = splitext(file)[1]
    modular_sim_outputs[sim_name] = load(joinpath(modular_sim_outputs_dir, file), "results")
  end
end


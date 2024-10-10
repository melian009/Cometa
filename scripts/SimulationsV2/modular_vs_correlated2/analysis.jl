using Pkg; Pkg.activate(".")
using FileIO
using DataFrames
using Statistics
using StatsBase
using JLD2

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

# extract "biotic_coeff", "migration_rate"and "fixed_interaction_mat" values from the simulation names (keys in the dictionaries). Here is how the keys look like: "params_migration_rate=5.0_biotic_coeff=2.0_fixed_interaction_mat_4". 

function extract_values(sim_name::String)
  # Define the regular expression pattern
  pattern = r"params_migration_rate=(\d+\.?\d*)_biotic_coeff=(\d+\.?\d*)_fixed_interaction_mat_(\d+)"

  # Match the pattern against the simulation name
  matched = Base.match(pattern, sim_name)

  # Extract the values from the match
  if matched !== nothing
    migration_rate = parse(Float64, matched.captures[1])
    biotic_coeff = parse(Float64, matched.captures[2])
    fixed_interaction_mat = parse(Int, matched.captures[3])
    return migration_rate, biotic_coeff, fixed_interaction_mat
  else
    error("The simulation name does not match the expected pattern.")
  end
end

# extract the values from the simulation names
correlated_sim_values = Dict()
for (sim_name, sim_output) in correlated_sim_outputs
    migration_rate, biotic_coeff, fixed_interaction_mat = extract_values(sim_name)
    correlated_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat)] = sim_output
end

modular_sim_values = Dict()
for (sim_name, sim_output) in modular_sim_outputs
    migration_rate, biotic_coeff, fixed_interaction_mat = extract_values(sim_name)
    modular_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat)] = sim_output
end


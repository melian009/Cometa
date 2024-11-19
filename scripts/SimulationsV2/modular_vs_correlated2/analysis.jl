using Pkg; Pkg.activate(".")
using FileIO
using ImageIO
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

# extract "biotic_coeff", "migration_rate"and "fixed_interaction_mat" values from the simulation names (keys in the dictionaries). Here is how the keys look like: "params_migration_rate=5.0_biotic_coeff=2.0_fixed_interaction_mat_4". 

function extract_values(sim_name::String)
  # Define the regular expression pattern
  pattern = r"params_migration_rate=(\d+\.?\d*)_biotic_coeff=(\d+\.?\d*)_fixed_interaction_mat_(\d+)_abiotic_coeff=(\d+\.?\d*)_selection_coeff=(\d+\.?\d*)"

  # Match the pattern against the simulation name
  matched = Base.match(pattern, sim_name)

  # Extract the values from the match
  if matched !== nothing
    migration_rate = parse(Float64, matched.captures[1])
    biotic_coeff = parse(Float64, matched.captures[2])
    fixed_interaction_mat = parse(Int, matched.captures[3])
    abiotic_coeff = parse(Float64, matched.captures[4])
    selection_coeff = parse(Float64, matched.captures[5])
    return migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff
  else
    error("The simulation name does not match the expected pattern.")
  end
end

# extract the values from the simulation names
correlated_sim_values = Dict()
for (sim_name, sim_output) in correlated_sim_outputs
    migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff = extract_values(sim_name)
    correlated_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff)] = sim_output
end

modular_sim_values = Dict()
for (sim_name, sim_output) in modular_sim_outputs
    migration_rate, biotic_coeff, fixed_interaction_mat = extract_values(sim_name)
    modular_sim_values[(migration_rate, biotic_coeff, fixed_interaction_mat)] = sim_output
end

function calculate_shannon_diversity_index(df::DataFrame; species_col::Symbol=:species_N)
  grouped = groupby(df, :ensemble)
  g1 = first(grouped)
  nrows, ncols = size(g1)
  nspecies = length(g1[1, species_col])
  shannon_div_all = zeros(nrows, length(grouped))
  for (replicate, gg) in enumerate(grouped)
    shannon_div = zeros(nrows)
    for generation in 1:nrows
      m = Array(gg[generation, species_col])
      totalsum = sum(m)
      species_freq = m ./ totalsum
      # Calculate Shannon index only for non-zero frequencies
      shannon = -sum(species_freq[species_freq.>0] .* log2.(species_freq[species_freq.>0]))

      shannon_div[generation] = shannon
    end
    shannon_div_all[:, replicate] = shannon_div
  end
  return vec(mean(shannon_div_all, dims=2))
end

div_per_sim = Dict()
for (params, df) in correlated_sim_values
  div_per_sim[params] = calculate_shannon_diversity_index(df)
end

div_per_sim_modular = Dict()
for (params, df) in modular_sim_values
  div_per_sim_modular[params] = calculate_shannon_diversity_index(df)
end


# sims sorted by one of the parameters

migration_rate, biotic_coeff, fixed_interaction_mat, abiotic_coeff, selection_coeff = 1:5

sorted_sims = sortperm(collect(keys(div_per_sim)), by=x->x[migration_rate])  # change the parameter to sort by as desired
sorted_keys = collect(keys(div_per_sim))[sorted_sims]

sorted_sims_modular = sortperm(collect(keys(div_per_sim_modular)), by=x -> x[migration_rate])
sorted_keys_modular = collect(keys(div_per_sim_modular))[sorted_sims_modular]

## Plot correlated
df1 = DataFrame()
df1.migration_rate = [mean(k[migration_rate]) for k in sorted_keys]
df1.biotic_coeff = [mean(k[biotic_coeff]) for k in sorted_keys]
df1.fixed_interaction_mat = [mean(k[fixed_interaction_mat]) for k in sorted_keys]
df1.abiotic_coeff = [mean(k[abiotic_coeff]) for k in sorted_keys]
df1.selection_coeff = [mean(k[selection_coeff]) for k in sorted_keys]
df1.diversity_index = [mean(div_per_sim[k]) for k in sorted_keys]

groups = groupby(df1, [:migration_rate, :selection_coeff])

# plot: heatmap where x axis is biotic coeff, y axis is abiotic coeff, color is diversity index
for group in groups
  p = group |> @vlplot(
    :rect,
    x = {:biotic_coeff, type = :quantitative, title = "Biotic coefficient"},
    y = {:abiotic_coeff, type = :quantitative, title = "Abiotic coefficient"},
    color={:diversity_index, scale={scheme="viridis"}},
    width=500,
    height=500
  )

  VegaLite.save(joinpath("plots", "correlated_heatmap_biotic_abiotic_diversity_$(group[1,:migration_rate])_$(group[1,:selection_coeff]).png"), p)
end

## Plot modular
df2 = DataFrame()
df2.migration_rate = [mean(k[migration_rate]) for k in sorted_keys_modular]
df2.biotic_coeff = [mean(k[biotic_coeff]) for k in sorted_keys_modular]
df2.fixed_interaction_mat = [mean(k[fixed_interaction_mat]) for k in sorted_keys_modular]
df2.diversity_index = [mean(div_per_sim_modular[k]) for k in sorted_keys_modular]

groups = groupby(df2, :migration_rate)

# plot: heatmap where x axis is biotic coeff, y axis is abiotic coeff, color is diversity index
for group in groups
  p = group |> @vlplot(
    :rect,
    x = {:biotic_coeff, type = :quantitative, title = "Biotic coefficient"},
    y = {:fixed_interaction_mat, type = :quantitative, title = "Fixed interaction matrix"},
    color={:diversity_index, scale={scheme="viridis"}},
    width=500,
    height=500
  )

  VegaLite.save(joinpath("plots", "modular_heatmap_biotic_fixed_diversity_$(group[1,:migration_rate]).png"), p)
end

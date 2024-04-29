using Pkg
Pkg.activate(".")
using DataFrames
using JLD2
using GLMakie  #CairoMakie
using Statistics
using DrWatson
using DataVoyager

# sim_output_dir = "sim_outputs_correlated"
sim_output_dir = "sim_outputs_modular"

function create_per_species_from_sims(sim_output_dir)
  sims = readdir(sim_output_dir)
  output_summary_all = DataFrame()

  for sim in sims
    simparams = parse_savename(sim[1:end-27])[2]
    simfile = joinpath(sim_output_dir, sim)
    df = load(simfile, "results")

    df_grouped = groupby(df, :ensemble)
    ensemble_summary = DataFrame()

    for (ensemble, group) in pairs(df_grouped)
      # Get the last, middle and mean values for each species
      last_N = group.species_N[end]
      middle_N = group.species_N[div(end, 2)]
      mean_N = vec(mean(reduce(hcat, group.species_N), dims=2))

      last_fitness = group.mean_fitness_per_species[end]
      middle_fitness = group.mean_fitness_per_species[div(end, 2)]
      mean_fitness = vec(mean(reduce(hcat, group.mean_fitness_per_species), dims=2))

      last_epistasis = group.mean_espistasis_matrix_per_species[end]
      middle_epistasis = group.mean_espistasis_matrix_per_species[div(end, 2)]
      mean_epistasis = vec(mean(reduce(hcat, group.mean_espistasis_matrix_per_species), dims=2))

      # Create a DataFrame row
      row = DataFrame(
        species = 1:10,
        ensemble = ensemble.ensemble,
        last_N=last_N,
        middle_N=middle_N,
        mean_N=mean_N,
        last_fitness=last_fitness,
        middle_fitness=middle_fitness,
        mean_fitness=mean_fitness,
        last_epistasis=last_epistasis,
        middle_epistasis=middle_epistasis,
        mean_epistasis=mean_epistasis
      )

      # Change the format of the `row` df such that there is an additional column called species for each row of the `row` dataframe
      row2 = stack(row, Not(:species, :ensemble))

      # Append the row to the ensemble summary
      append!(ensemble_summary, row2)
    end

    # Calculate the mean across ensembles and append to the output summary
    summary_grouped_by_species = groupby(ensemble_summary, :species)
    output_summary = DataFrame()
    for group in summary_grouped_by_species
      mean_values_across_ensembles = combine(groupby(group, [:species, :variable]), :value => mean)

      # add parameter columns to mean_values_across_ensembles
      for (key, value) in simparams
        mean_values_across_ensembles[!, key] .= value
      end
      append!(output_summary, mean_values_across_ensembles)
    end
    append!(output_summary_all, output_summary)
  end

  return output_summary_all
end

summary = create_per_species_from_sims(sim_output_dir)

Voyager(summary)

# ## Plots

# f = Figure(resolution=(800, 500))
# ax = Axis(f[1, 1],
#   xlabel="Migration threshold",
#   ylabel="Biotic variance (higher -> more interactions)",
#   # yscale = Makie.pseudolog10
# )

# heatmap(summary.migration, summary.biotic_variance, hcat(summary.survived_species_count_at_midtime, summary.survived_species_count_at_the_end))


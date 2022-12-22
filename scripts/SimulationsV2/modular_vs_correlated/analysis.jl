using Pkg
Pkg.activate(".")
using DataFrames
using JLD2
using GLMakie  #CairoMakie
using Statistics
using DrWatson
using DataVoyager

sim_output_dir = "sim_outputs/"


function create_stats_from_sims(sim_output_dir)
  sims = readdir(sim_output_dir)
  output_summary = DataFrame(
    :migration => Float64[],
    :biotic_variance => Float64[],
    :mean_N_at_the_end => Float64[],
    :max_N_at_the_end => Float64[],
    :survived_species_count_at_the_end => Float64[],
    :mean_N_at_midtime => Float64[],
    :max_N_at_midtime => Float64[],
    :survived_species_count_at_midtime => Float64[],
  )

  for sim in sims
    simparams = parse_savename(sim[1:end-27])[2]
    # create df
    simfile = joinpath(sim_output_dir, sim)
    df = load(simfile, "results")
    dfn = combine(df, :step, :species_N => [Symbol("s$i") for i in 1:10], :ensemble)
    gdf = groupby(dfn, :step)
    fdf = combine(gdf, [Symbol("s$i") for i in 1:10] .=> mean)
    # extract statistics
    meansize = mean(fdf[size(fdf, 1), 2:size(fdf, 2)])
    maxsize = maximum(fdf[size(fdf, 1), 2:size(fdf, 2)])
    nsurviedspecies = count(x -> x > 10, fdf[size(fdf, 1), 2:size(fdf, 2)])
    # same statistics by at half the time
    midgen = round(Int, size(fdf, 1) / 2)
    meansizehalf = mean(fdf[midgen, 2:size(fdf, 2)])
    maxsizehalf = maximum(fdf[midgen, 2:size(fdf, 2)])
    nsurviedspecieshalf = count(x -> x > 10, fdf[midgen, 2:size(fdf, 2)])

    # save
    entry = [simparams["migration_rate"], simparams["biotic_coeff"], meansize, maxsize, nsurviedspecies, meansizehalf, maxsizehalf, nsurviedspecieshalf]
    push!(output_summary, entry)
  end

  return output_summary
end

summary = create_stats_from_sims(sim_output_dir)


## Plots

f = Figure(resolution=(800, 500))
ax = Axis(f[1, 1],
  xlabel="Migration threshold",
  ylabel="Biotic variance (higher -> more interactions)",
  # yscale = Makie.pseudolog10
)

heatmap(summary.migration, summary.biotic_variance, hcat(summary.survived_species_count_at_midtime, summary.survived_species_count_at_the_end))


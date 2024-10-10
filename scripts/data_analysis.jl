using Pkg
Pkg.activate(".")
using DrWatson
@quickactivate
using CSV
using DataFrames
using VegaLite
using Statistics
using LinearAlgebra
using HypothesisTests
include(srcdir("data_analysis.jl"))

# 1. Read data

cooccur_mat, traits = call_in_data();

# 2. retrieve distance from modularity for each species per lake
species, ponds, sumdist_all, meddist_all, meddist_only_positive_all = modularity_distance_per_sp_pond(cooccur_mat, traits);

# 3. retrieve the number of species per pond
n_species_per_pond = sum(Matrix(cooccur_mat[:, 2:end]), dims=2);

pond_order = string.(cooccur_mat[1]);

# 4. merge all the data to the same df
final_df = DataFrame(
  :species => species,
  :pond => ponds,
  :dist_sum => sumdist_all,
  :dist_med => meddist_all,
  :dist_med_only_pos => meddist_only_positive_all,
  :n_species_in_pond => n_species_per_pond[[findfirst(x->x==i, pond_order) for i in ponds]]
);

# Plot Richness as a function of modularity per species per charco (all data points or mean, median of the community)
p = final_df |> @vlplot(
  mark = :point,
  x = {
    :dist_sum,
    axis = {
      title = "Sum distance from modularity"
    }
  },
  y = {
    :n_species_in_pond,
    axis = {
      title = "Number of species per pond"
    }
  }
)

p2 = final_df |> @vlplot(
  mark = :point,
  x = {
    :dist_med,
    axis = {
      title = "Median distance from modularity (all)"
    }
  },
  y = {
    :n_species_in_pond,
    axis = {
      title = "Number of species per pond"
    }
  }
)

VegaLite.save(plotsdir("med_distance_from_modularity_vs_number_species_per_pond.pdf"), p2)

p3 = final_df |> @vlplot(
  mark = :point,
  x = {
    :dist_med_only_pos,
    axis = {
      title = "Median distance from modularity (only positive)"
    }
  },
  y = {
    :n_species_in_pond,
    axis = {
      title = "Number of species per pond"
    }
  }
)

VegaLite.save(plotsdir("med_distance_from_modularity_only_pos_vs_number_species_per_pond.pdf"), p3)

pall = @vlplot() + [p2 p3]
VegaLite.save(plotsdir("med_distance_from_modularity_vs_number_species_per_pond.pdf"), pall)

# Correlation significance
OneSampleZTest(atanh(cor(final_df.dist_med, final_df.n_species_in_pond)), 1, nrow(final_df)-3) # p = 0.0180
OneSampleZTest(atanh(cor(final_df.dist_med_only_pos, final_df.n_species_in_pond)), 1, nrow(final_df)-3) # p = 0.0180
using DrWatson
@quickactivate
using CSV
using DataFrames
using VegaLite
using Statistics
include(srcdir("data_analysis.jl"))

# Read data
cooccur_mat, traits = call_in_data()

# Covariance matrix per species per pond
# covar_trait(species="Lobelia_hederacea", charco="41"; traits = traits)


# TODO 
# Normalize covariance matrix per species per charco where diff(0) is perfectly modular and dif(max), is the maximum correlation value of the dataset
# Plot Richness as a function of modularity per species per charco (all data points or mean, median of the community)
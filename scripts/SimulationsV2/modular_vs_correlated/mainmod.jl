using Distributed
using Pkg
Pkg.activate(".")
addprocs(6)
@everywhere using EvoDynamics
using JLD2
using FileIO
using Distributions
include("data_collection_functions.jl")

pf = "parameters_frame.jl"
paramdir = "parameter_files_modular/"
results_dir = "sim_outputs_modular/"

migration_thresholds = [0.0, 0.1, 1.0, 2.0, 5.0, 10.0]
biotic_variances = [0.0, 0.1, 0.5, 1.0, 2.0, 5.0]


# ################################################################
# ## Only change the migration_threshold and biotic_variance
# ################################################################

# function create_single_parameter_file(pf, migration_rate, biotic_coeff, paramdir=paramdir)
#   if !isdir(paramdir)
#     mkdir(paramdir)
#   end
#   outfile = joinpath(paramdir, "params_migration_rate=$(migration_rate)_biotic_coeff=$(biotic_coeff)_fixed_interaction_mat.jl")
#   input = readlines(pf)
#   # Update migration threshold
#   lines = findall(x -> startswith(strip(x), ":migration_threshold"), input)
#   input[lines] .= ":migration_threshold => $(migration_rate),"

#   # Update biotic variance
#   lines = findall(x -> startswith(strip(x), ":biotic_variance"), input)
#   input[lines] .= ":biotic_variance => $(biotic_coeff),"

#   open(outfile, "w") do ff
#     for line in input
#       println(ff, line)
#     end
#   end
#   return outfile
# end

# function create_parameter_combinations(pf, migration_rates, biotic_coeffs, paramdir=paramdir)
#   for mrate in migration_rates
#     for biocoef in biotic_coeffs
#       create_single_parameter_file(pf, mrate, biocoef, paramdir)
#     end
#   end
# end

# create_parameter_combinations(pf, migration_thresholds, biotic_variances, paramdir)

# all_parameter_files = readdir(paramdir)

# for f in all_parameter_files
#   param_file = joinpath(paramdir, f)
#   adata, mdata, models = runmodel(param_file, replicates=7, parallel=true)
#   if !isdir(results_dir)
#     mkdir(results_dir)
#   end
#   save(joinpath(results_dir, "$(f[1:end-3]).jld2"), "results", mdata)
# end


###################################################################
## Other variations of the create_single_parameter_file function
###################################################################

pmat = Bool[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]  # the original pleiotropy_matrix that we will randomize a little bit
pmat_variations = 10
nreplicates = 7
nchanges_mean = 2

"""
A variation of the create single_parameter_file function that adds random 1's to the pleiotropy_matrix

## Parameters

* nchanges_mean: mean of a Poisson distribution for the number of 0s in the pleiotropy_matrix that will change to 1.
"""
function create_single_parameter_file_add_noise_to_pleiotropy(pf, pmat, pmatnum, migration_rate, biotic_coeff, paramdir=paramdir, nchanges_mean=2)
  if !isdir(paramdir)
    mkdir(paramdir)
  end
  outfile = joinpath(paramdir, "params_migration_rate=$(migration_rate)_biotic_coeff=$(biotic_coeff)_fixed_interaction_mat_$(pmatnum).jl")
  input = readlines(pf)
  # Update migration threshold
  lines = findall(x -> startswith(strip(x), ":migration_threshold"), input)
  input[lines] .= ":migration_threshold => $(migration_rate),"

  # Update biotic variance
  lines = findall(x -> startswith(strip(x), ":biotic_variance"), input)
  input[lines] .= ":biotic_variance => $(biotic_coeff),"

  # Add some ones to the pleiotropy_matrix
  lines = findall(x -> startswith(strip(x), ":pleiotropy_matrix"), input)
  nchanges_dist = Poisson(nchanges_mean)
  nchanges = rand(nchanges_dist)
  pmat2 = deepcopy(pmat)
  pmat2[rand(findall(x -> x == false, pmat), nchanges)] .= true
  input[lines] .= ":pleiotropy_matrix => $(pmat2),"

  open(outfile, "w") do ff
    for line in input
      println(ff, line)
    end
  end
  return outfile
end

function create_parameter_combinations(pf, pmat, migration_rates, biotic_coeffs, paramdir=paramdir, nchanges_mean=2)
  for mrate in migration_rates
    for biocoef in biotic_coeffs
      for pmatnum in 1:pmat_variations
        create_single_parameter_file_add_noise_to_pleiotropy(pf, pmat, pmatnum, mrate, biocoef, paramdir, nchanges_mean)
      end
    end
  end
end

create_parameter_combinations(pf, pmat, migration_thresholds, biotic_variances, paramdir, nchanges_mean)

all_parameter_files = readdir(paramdir)

for f in all_parameter_files
  param_file = joinpath(paramdir, f)
  adata, mdata, models = runmodel(param_file, replicates=nreplicates, mdata=[EvoDynamics.mean_fitness_per_species, EvoDynamics.species_N, mean_espistasis_matrix_per_species], parallel = true)
  if !isdir(results_dir)
    mkdir(results_dir)
  end
  save(joinpath(results_dir, "$(f[1:end-3]).jld2"), "results", mdata)
end



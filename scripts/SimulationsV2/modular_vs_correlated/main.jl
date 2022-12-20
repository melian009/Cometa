using Distributed
using Pkg
Pkg.activate(".")
addprocs(6)
@everywhere using EvoDynamics
using JLD2
using FileIO


pf = "parameters_frame.jl"
paramdir = "parameter_files/"
results_dir = "sim_outputs/"

migration_thresholds = [0.0, 0.1, 1.0, 2.0, 5.0, 10.0]
biotic_variances = [0.0, 0.1, 1.0, 2.0, 5.0, 10.0]

function create_single_parameter_file(pf, migration_rate, biotic_coeff, paramdir=paramdir)
  if !isdir(paramdir)
    mkdir(paramdir)
  end
  mkdir(paramdir)
  outfile = joinpath(paramdir, "params_migration_rate=$(migration_rate)_biotic_coeff=$(biotic_coeff)_fixed_interaction_mat.jl")
  input = readlines(pf)
  # Update migration threshold
  lines = findall(x -> startswith(strip(x), ":migration_threshold"), input)
  input[lines] .= ":migration_threshold => $(migration_rate),"

  # Update biotic variance
  lines = findall(x -> startswith(strip(x), ":biotic_variance"), input)
  input[lines] .= ":biotic_variance => $(biotic_coeff),"

  open(outfile, "w") do ff
    for line in input
      println(ff, line)
    end
  end
  return outfile
end

function create_parameter_combinations(pf, migration_rates, biotic_coeffs, paramdir=paramdir)
  for mrate in migration_rates
    for biocoef in biotic_coeffs
      create_single_parameter_file(pf, mrate, biocoef, paramdir)
    end
  end
end

create_parameter_combinations(pf, migration_thresholds, biotic_variances, paramdir)

all_parameter_files = readdir(paramdir)

for f in all_parameter_files
  param_file = joinpath(paramdir, f)
  adata, mdata, models = runmodel(param_file, replicates=7, parallel=true, showprogress=true)
  if !isdir(results_dir)
    mkdir(results_dir)
  end
  save(joinpath(results_dir, "$(f[1:end-3]).jld2"), "results", mdata)
end

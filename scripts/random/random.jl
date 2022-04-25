using EvoDynamics
using Agents
using Distributions
using Random
using LinearAlgebra


param_file = "params.yml"
adata, mdata, models = runmodel(param_file)

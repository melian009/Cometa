
# # Weak modular structure
using Distributed
@everywhere begin
using EvoDynamics
using Agents
using Distributions
using Random
using LinearAlgebra
using CSV
using JLD2, FileIO


function nspecies_per_node(model)
  output = zeros(model.properties[:nspecies], nv(model))
  for species in model.properties[:nspecies]
    for node in 1:nv(model)
      for ag in get_node_contents(node, model)
        output[model.agents[ag].species, node] += 1
      end
    end
  end
  return Tuple(output)
end


for rep in 1:100

nspecies = 10
P = fill(3, nspecies)
L = fill(3, nspecies)
m = fill(1, nspecies)
A = Tuple([rand(Normal(0, 0.01), i, i) for i in (L .* m)])
# choose random values for epistasis matrix A, but make sure the diagonal is
# 1.0, meaning that each locus affects itself 100%.
for index in 1:length(A)
  for diag in 1:size(A[index], 1)
    A[index][diag, diag] = 1.0
  end
end

Ω = Tuple([rand(Normal(0, 3), i[1], i[2]) for i in zip(P, P)])
for index in 1:length(Ω)
  for diag in 1:size(Ω[index], 1)
    Ω[index][diag, diag] = 1.0
  end
end


mig = rand(10, 10)
mig[LinearAlgebra.diagind(mig)] .= 1.0

parameters = Dict(
  :L => L .* m,
  :P => P,
  :R => fill(0.1, nspecies),
  :C => rand(Normal(0, 0.1), nspecies, nspecies),#interaction coefficients
  :B => Tuple([LinearAlgebra.diagm(fill(true, max(P[i], L[i] * m[i]))) for i in 1:nspecies]),
  :A =>  A,
  :Q => Tuple([rand() for el in 1:l] for l in L .* m),
  :Y => fill(0.0, nspecies),
  :m => m,
  :T => Tuple([randn(Float16, n) for n in P]),
  :Ω => Ω,
  :M => Tuple([(0.02, 0.0, 0.0) for i in 1:nspecies]),
  :D => Tuple([(0.01, 0.0, 0.01) for i in 1:nspecies]),
  :N => Dict(i => fill(100, nspecies) for i in 1:nspecies),
  :K => Dict(i => fill(1000, nspecies) for i in 1:nspecies),
  :migration_rates => [mig for i in 1:nspecies],
  :E => Tuple(0.001 for i in 1:nspecies),
  :generations => 100,
  :space => (5,2),
)

    data, model = runmodel(parameters, collect=Dict(:model => [nspecies_per_node]));
    CSV.write("data_$rep.csv", data)
    save("model_$rep.jld2", "model", model)
end

# # Strong modular structure

using EvoDynamics
using Agents
using Distributions
using Random
using LinearAlgebra
using CSV
using JLD2, FileIO

nspecies = 10
nphenotypes = fill(3, nspecies)
ngenes = fill(3, nspecies)
ploidy = fill(1, nspecies)
epistasisMat = Tuple([rand(Normal(0, 0.01), i, i) for i in (ngenes .* ploidy)])
# choose random values for epistasis matrix epistasisMat, but make sure the diagonal is
# 1.0, meaning that each locus affects itself 100%.
for index in 1:length(epistasisMat)
  for diag in 1:size(epistasisMat[index], 1)
    epistasisMat[index][diag, diag] = 1.0
  end
end

# covMat = Tuple([rand(Normal(0, 3), i[1], i[2]) for i in zip(nphenotypes, nphenotypes)])#Magic diag == 1, rand off-diag
# for index in 1:length(covMat)
#   for diag in 1:size(covMat[index], 1)
#     covMat[index][diag, diag] = 1.0
#   end
# end

mig = rand(10, 10)
mig[LinearAlgebra.diagind(mig)] .= 1.0

parameters = Dict(
  :ngenes => ngenes .* ploidy,
  :nphenotypes => nphenotypes,
  :growthrates => fill(0.1, nspecies),
  :competitionCoeffs => rand(Normal(0, 0.1), nspecies, nspecies),
  :pleiotropyMat => Tuple([LinearAlgebra.diagm(fill(true, max(nphenotypes[i], ngenes[i] * ploidy[i]))) for i in 1:nspecies]),
  :epistasisMat =>  epistasisMat,
  :expressionArrays => Tuple([rand() for el in 1:l] for l in ngenes .* ploidy),
  :selectionCoeffs => fill(0.0, nspecies),
  :ploidy => ploidy,
  :optPhenotypes => Tuple([randn(n) for n in nphenotypes]),
  :covMat => Tuple([LinearAlgebra.diagm(fill(1.0, max(i[1], i[2]))) for i in zip(nphenotypes, nphenotypes)]),
  :mutProbs => Tuple([(0.02, 0.0, 0.0) for i in 1:nspecies]),
  :mutMagnitudes => Tuple([(0.01, 0.0, 0.01) for i in 1:nspecies]),
  :N => Dict(i => fill(100, nspecies) for i in 1:nspecies),
  :K => Dict(i => fill(1000, nspecies) for i in 1:nspecies),
  :migration_rates => [mig for i in 1:nspecies],
  :E => Tuple(0.001 for i in 1:nspecies),
  :generations => 100,
  :space => (5,2),
);

function nspecies_per_node(model)
  output = zeros(model.properties[:nspecies], nv(model))
  for species in model.properties[:nspecies]
    for node in 1:nv(model)
      for ag in get_node_contents(node, model)
        output[model.agents[ag].species, node] += 1
      end
    end
  end
  return Tuple(output)
end
end
agentdata, modeldata, model = runmodel(parameters, mdata=[nspecies_per_node], replicates=100, parallel=true);
CSV.write("data.csv", modeldata)
save("model.jld2", "model", model)
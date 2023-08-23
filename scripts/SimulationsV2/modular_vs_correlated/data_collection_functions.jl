"""
    mean_fitness_per_species(model::ABM)

Returns a tuple whose entries are the mean of mean of the epistasis matrix per individual of each species.
"""
function mean_espistasis_matrix_per_species(model::ABM)
  mean_epistasis = Array{Float64}(undef, model.nspecies)
  for species in 1:model.nspecies
    fitness = mean([mean(i.epistasisMat) for i in values(model.agents) if i.species == species])
    mean_epistasis[species] = fitness
  end

  return mean_epistasis
end
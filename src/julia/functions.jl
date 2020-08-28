# These functions are used in analysis.jl

"""
    shannonIndex(csvfile; nspecies=10)

Calculates Shannon diversity index per site.
The function input is a simulation result file in CSV format.

# keyword arguments
* nspecies=10: maximum number of species
"""
function shannonIndex(csvfile; nspecies=10)
  df = CSV.read(csvfile, DataFrame)
  nrows, ncols = size(df)
  nsites = Int((ncols-1) / nspecies)
  generations = zeros(nrows, nsites)
  for generation in 1:nrows
    m = reshape(Array(df[generation, 2:end]), nspecies, nsites)
    totalsum = sum(m, dims=1)
    species_freq = m ./ totalsum
    shannon = - sum(log2.(species_freq) .* species_freq, dims=1)
    generations[generation, :] = shannon
  end
  return generations
end
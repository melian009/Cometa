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

"""
Reads all `csv` files in `directory`, calculates `shannonIndex` for each one of them, and takes the values in row `gen`, and puts them all in a matrix, and returns the matrix.
"""
function shannonIndexDir(directory, gen=101; nsites=10, nspecies=10)
  outmat = Array{Float64, 2}(undef, 0, 0)
  first = true
  for ff in readdir(directory, join=true)
    if endswith(ff, ".csv")
      si = shannonIndex(ff, nspecies=nspecies)
      row = si[gen, :]
      if first
        first = false
        outmat = row
      else
        outmat = hcat(outmat, row)
      end
    end
  end
  return outmat
end
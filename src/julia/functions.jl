# These functions are used in analysis.jl

function read_sims(csvfile)
  df = CSV.read(csvfile, DataFrame)
end
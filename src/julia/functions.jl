# These functions are used in analysis.jl

function read_sims(csvfile)
  df = CSV.read(csvfile, DataFrame)
end

function shannonIndex(model)
  output = zeros(nv(model))
  for node in 1:nv(model)
    species_freq = zeros(model.properties[:nspecies])
    for ag in get_node_contents(node, model)
      species_freq[model.agents[ag].species] += 1
    end
    species_freq = species_freq ./ sum(species_freq)
    shannon = - sum(log2.(species_freq) .* species_freq)
    output[node] = shannon
  end
  return output
end
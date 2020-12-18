"Converts non-number columns to numbers"
function change_coltypes!(df)
  for col in 1:size(df, 2)
    if eltype(df[col]) <: Real
      continue
    else
      newcol = parse.(Float64, df[col])
      df[!, col] = newcol
    end
  end
  return df
end

"Create a covariance matrix for each species."
function covar_trait(species="Lobelia_hederacea", charco="41"; traits = traits)
  trait_cols = [8, 9, 11, 12, 13, 14, 15, 16, 17, 18]
  species_traits = dropmissing(traits[.&(traits.Charco .== charco, traits.Especie .== species), trait_cols])
  if size(species_traits, 1) < 2
    return []
  end
  change_coltypes!(species_traits)
  return cov(Matrix(species_traits))
end

function call_in_data()
  # Number of species per pond
  cooccur_file = datadir("coccurrence.csv")
  cooccur = CSV.read(cooccur_file, DataFrame)
  # We use the split-apply-combine functionality in DataFrames.jl: https://dataframes.juliadata.org/stable/man/split_apply_combine/
  colnames = names(cooccur)
  df1 = groupby(cooccur, :Charco);
  cooccur_mat = combine(df1, :Alternanthera_philoxeroides => sum)
  for colname in colnames[4:end] 
    t = combine(df1, Symbol(colname) => sum)
    cooccur_mat[!, names(t)[2]] = t[!, 2]
  end

  # Read species traits
  traits_file = datadir("multitrait.csv")
  traits = CSV.read(traits_file, DataFrame)

  # There are 66 species in cooccur_mat and 76 species in traits. 60 of them have identical names.
  shared_species = intersect(colnames[3:end], traits[!, :Especie])

  missing_species = String[] # Species not in traits
  for sp in colnames[3:end]
    if !in(sp, traits[!, :Especie])
      push!(missing_species, sp)
    end
  end

  missing_species_traits = Set() # The 16 species not in cooccur
  for sp in traits[!, :Especie]
    if !in(sp, colnames[3:end])
      push!(missing_species_traits, sp)
    end
  end

  # subset the two datasets with the shared species
  traits_keep_rows = [in(traits[!, :Especie][i], shared_species) for i in 1:size(traits, 1)]
  traits = traits[traits_keep_rows, :]
  cooccur_mat = cooccur_mat[!, vcat(colnames[1],shared_species .* "_sum")]

  # Rename colnames in cooccur to only inlcude species names, not "_sum"
  rename!(cooccur_mat, Dict(i => j for (i, j) in zip(names(cooccur_mat)[2:end], shared_species)))

  # put NA for two missing values in traits.Charco
  traits[findall(ismissing.(traits.Charco)), :Charco] .= "NA"

  return cooccur_mat, traits 
end

function sum_abs_distance_from_zero(mat, upperindices)
  sum(abs.(mat[upperindices]))
end

function median_abs_distance_from_zero(mat, upperindices)
  median(abs.(mat[upperindices]))
end

function median_abs_distance_from_zero_only_pos(mat, upperindices)
  only_positive = findall(mat .> 1)
  return median(mat[intersect(upperindices, only_positive)])
end

function triu_indices(ntraits)
  j = ones(ntraits, ntraits)
  uppertri = triu(j, 1)
  upperindices = findall(x-> x==1, uppertri)
  return upperindices
end

function modularity_distance_per_sp_pond(cooccur_mat, traits)
  species_all = []
  ponds_all = []
  sumdist_all = Float64[]
  meddist_all = Float64[]
  meddist_only_positive_all = Float64[]

  ponds = levels(cooccur_mat.Charco);
  species = names(cooccur_mat)[2:end];
  upperindices = triu_indices(ntraits)
  for sp in species
    for pond in ponds
      # println(sp, pond)
      mat = covar_trait(sp, string(pond); traits = traits)
      if length(mat) > 1
        sumdis = sum_abs_distance_from_zero(mat, upperindices)
        meddis = median_abs_distance_from_zero(mat, upperindices)
        meddist_only_pos = median_abs_distance_from_zero_only_pos(mat, upperindices)

        # collect data
        push!(species_all, sp)
        push!(ponds_all, string(pond))
        push!(sumdist_all, sumdis)
        push!(meddist_all, meddis)
        push!(meddist_only_positive_all, meddist_only_pos)
      end
    end
  end
  return species_all, ponds_all, sumdist_all, meddist_all, meddist_only_positive_all
end
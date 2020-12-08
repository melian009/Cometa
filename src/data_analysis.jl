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
    return
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

  return cooccur_mat, traits 
end
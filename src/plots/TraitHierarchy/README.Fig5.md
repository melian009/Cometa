#Cometa Option 1
sort!(df_div, [:biotic_coeff, :abiotic_coeff])
biotic_vals = unique(df_div.biotic_coeff)
abiotic_vals = unique(df_div.abiotic_coeff)
# Reshape into matrix N1
for i in 1:size(df_div, 1)
        xi = data[i, x]
        yi = data[i, y]
        vi = data[i, v]
        A[D1[xi], D2[yi]] = vi
    end

z = reshape(df_div.correlated_div, length(biotic_vals), length(abiotic_vals))
heatmap(biotic_vals,abiotic_vals,z,xlabel="biotic variance",ylabel="abiotic variance",title="",colorbar_title="Correlated div",c=:viridis)



#Cometa Option 2
# Return data required for heatmap

data |> @vlplot(:rect, x=:src, y=:dst, color=:val)
function make_heatmap_data(df_div, biotic_coeff, abiotic_coeff, correlated_div)
    xs = unique(df_div.biotic_coeff)
    ys = unique(df_div.abiotic_coeff)
   
    n = length(xs)
    m = length(ys)
    A = zeros((n, m))
    D1 = Dict(biotic_coeff => i for (i,biotic_coeff) in enumerate(xs))
    D2 = Dict(abiotic_coeff => i for (i,abiotic_coeff) in enumerate(ys))
    for i in 1:size(df_div, 1)
        xi = df_div[i, biotic_coeff]
        yi = df_div[i, abiotic_coeff]
        vi = df_div[i, correlated_div]
        A[D1[xi], D2[yi]] = vi
    end
    (xs, ys, A)
end

let (x, y, A) = make_heatmap_data(data, :src, :dst, :val)
    heatmap(x, y, A, seriescolor = :blues, size = (400,300))
end





# Reshape into matrix N2
z = reshape(df3.N_2, length(H_vals), length(cij_vals))  # rows = H, cols = cij
heatmap(cij_vals,H_vals,z,xlabel="cij",ylabel="H",title="Heatmap of N_2",colorbar_title="N_2",c=:viridis)


#Scatter Fig 4
scatter3d(df_div.biotic_coeff,df_div.abiotic_coeff,df_div.div_diff,marker=:circle,seriestype = :scatter,xlabel="Biotic variance", ylabel="abiotic variance",zlabel="Correlated - Modular Div",ylimits=(0,6),xlimits=(0,6),zlimits=(-1,1),label=false)



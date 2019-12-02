using EcologicalNetworks
using EcologicalNetworksPlots
using Plots
using CSV
using DataFrames

##################################
##################################
df = CSV.read("WoodEtal_Append1_v2.csv")

# Separate based on WebScale
scale = [df[df.WebScale .== u,:] for u in unique(df.WebScale)]

# select for edge interaction columns only
edgelist_A = scale[3][:, [:PredTSN, :PreyTSN]]

# remove the "san" from the dataframe itself
edgelist_A.PredTSN = replace.(edgelist_A.PredTSN, "san" .=> "")

### Do the same for PreyTSN
# remove the "san" from the dataframe itself
edgelist_A.PreyTSN = replace.(edgelist_A.PreyTSN, "san" .=> "")
edgelist_A

# convert "string" to "integer"
edgelist_A.PredTSN = parse.(Int64, edgelist_A.PredTSN)
edgelist_A.PreyTSN = parse.(Int64, edgelist_A.PreyTSN)

#############################################
##Change PredTSN to newID starting from 1
# Sort by ID
sort!(edgelist_A, :PredTSN)
# Get unique IDs
unique_ids = unique(edgelist_A.PredTSN)
#create new IDs
newid_pred = collect(1:length(unique_ids))
# Create Dict where id => newid
id_dict = Dict(unique_ids[i] => newid_pred[i] for i in 1:length(unique_ids))
# Add new ids in dataframe
edgelist_A.newPredID = [id_dict[id] for id in edgelist_A.PredTSN]

### Do same for prey
## Change PreyTSN to new ID starting from end of newPredID
# Sort by ID
sort!(edgelist_A, :PreyTSN)
# Get unique IDs
unique_ids_prey = unique(edgelist_A.PreyTSN)
# Create new IDs
newid_prey = collect(length(id_dict)+1:length(id_dict)+length(unique_ids_prey))
# Create Dict
id_dict2 = Dict(unique_ids_prey[i] => newid_prey[i] for i in 1:length(unique_ids_prey))
# Add new ids in dataframe
edgelist_A.newPreyID = [id_dict2[id] for id in edgelist_A.PreyTSN]

A = edgelist_A[:, [:newPredID, :newPreyID]]

#sort
sort!(A, :newPredID)

#get unique values
unique!(A)

#add undirected interactions
y = vcat(A.newPredID, A.newPreyID)
x = vcat(A.newPreyID, A.newPredID)
A = DataFrame(hcat(y, x))

rename!(A, :x1 => :newPredID)
rename!(A, :x2 => :newPreyID)

sort!(A, :newPredID)

#############################################

##Create Adjacency matrix
#create matrix of zeros with n = colPred, m = colPrey
M = zeros(Int16, length(unique(A.newPredID)), length(unique(A.newPreyID)))

## Fill adjacency matrix with ones where there are interactions
for i in 1:length(A.newPredID)
    M[A[i, 1], A[i, 2]] = 1
end
M

#################################################

# Convert ones and zeros in boolean
M_bool = convert(Array{Bool}, M .== 1)

# Convert matrix in bipartite network
B = BipartiteNetwork(M_bool)

#################################################

#create figure
graph_A = heatmap(B, c=ColorGradient([:white, :green]), legend=false, title="Matrice d'Intéractions de l'Archipel", xaxis="ProieID", yaxis="PrédateurID")
png("figures/undirected_unipartite_int_mat.png")

include("required.jl")

##Change PredTSN to newID starting from 1
# Sort by ID
sort!(edgelist_T, :PredTSN)
# Get unique IDs
unique_ids = unique(edgelist_T.PredTSN)
# Create Dict where id => newid
id_dict = Dict(id => indexin(id, unique_ids) for id in edgelist_T.PredTSN)
# Add new ids in dataframe
edgelist_T.newPredID = [id_dict[id] for id in edgelist_T.PredTSN]


### Do same for prey
## Change PreyTSN to new ID starting from end of newPredID
# Sort by ID
sort!(edgelist_T, :PreyTSN)
# Get unique IDs
unique_ids_prey = unique(edgelist_T.PreyTSN)
# Create new IDs
newid_prey = collect(length(id_dict)+1:length(id_dict)+length(unique_ids_prey))
# Create Dict
id_dict2 = Dict(unique_ids_prey[i] => newid_prey[i] for i in 1:length(unique_ids_prey))
# Add new ids in dataframe
edgelist_T.newPreyID = [id_dict2[id] for id in edgelist_T.PreyTSN]

transect = edgelist_T[:, [:newPredID, :newPreyID]]

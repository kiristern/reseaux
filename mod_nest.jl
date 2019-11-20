using CSV
using DataFrames
using DataFramesMeta
using LightGraphs
using GraphPlot

df = CSV.read("/Users/kiristern/Desktop/BIO6037/devoir2/data/WoodEtal_Append1_v2.csv")

# Separate based on WebScale
scale = [df[df.WebScale .== u,:] for u in unique(df.WebScale)]

scale[1]

# select for edge interaction columns only
edgelist_T = scale[1][:, [:PredTSN, :PreyTSN]]

# view all entries that contain "san" in PredTSN
pred_san = edgelist_T[startswith.(edgelist_T.PredTSN, "san"),:]
pred_san.PredTSN = replace.(pred_san.PredTSN, "san" .=> "")
pred_san
#view unique predID without san
unique(pred_san,1)
edgelist_T.PredTSN == "102" #manually check if in original df

# alternative
backup = copy(edgelist_T)
old_ids = unique(backup.PredTSN)
# keep the indexes before the change
pred_indexes = startswith.(edgelist_T.PredTSN, "san")
# remove the "san" from the dataframe itself
edgelist_T.PredTSN = replace.(edgelist_T.PredTSN, "san" .=> "")
edgelist_T
#view unique preyIDs without san
check_uniques = [in(new_id, old_ids) for new_id in edgelist_T.PredTSN[pred_indexes]]
filter(isone, check_uniques)

##### Do the same for PreyTSN
backup2 = copy(edgelist_T)
old_ids2 = unique(backup2.PreyTSN)
# keep the indexes before the change
prey_indexes = startswith.(edgelist_T.PreyTSN, "san")
# remove the "san" from the dataframe itself
edgelist_T.PreyTSN = replace.(edgelist_T.PreyTSN, "san" .=> "")
edgelist_T
#check unique preyIDs without san
check_uniques2 = [in(new_id2, old_ids2) for new_id2 in edgelist_T.PreyTSN[prey_indexes]]
filter(isone, check_uniques2)

edgelist_T = edgelist_T[:, [:newPredID, :newPreyID]]

##Change PredTSN to newID starting from 1
# Sort by ID
sort!(edgelist_T, :PredTSN)
# Get unique IDs
unique_ids = unique(edgelist_T.PredTSN)
# Create Dict where id => newid
id_dict = Dict(id => indexin(id, unique_ids) for id in edgelist_T.PredTSN)
# Add new ids in dataframe
edgelist_T.newPredID = [id_dict[id] for id in edgelist_T.PredTSN]

##Change PreyTSN to new ID starting from end of newPredID
# sort by ID
sort!(edgelist_T, :PreyTSN)
#get unique IDs
unique_ids_prey = unique(edgelist_T.PreyTSN)
# Create new IDs
newid_prey = collect(length(id_dict)+1:length(id_dict)+length(unique_ids_prey))
# Create Dict
id_dict2 = Dict(unique_ids_prey[i] => newid_prey[i] for i in 1:length(unique_ids_prey))
# Add new ids in dataframe
edgelist_T.newPreyID = [id_dict2[id] for id in edgelist_T.PreyTSN]

edgelist_T


# convert "string" to "integer"
# edgelist_T.PredTSN = parse.(Int64, edgelist_T.PredTSN)
# edgelist_T.PreyTSN = parse.(Int64, edgelist_T.PreyTSN)

#create vertices
G = Graph()
add_vertices!(G, 5289)

#assign edges
for i in 1:length(edgelist_T)
    for j in 1:nrow(edgelist_T)
        add_edge!(G, edgelist_T[i][j])
    end
end


# create adjency matrix from edge list


# graph Adjacency matrix
Graph(edgelist_T)


#test
G = Graph()
add_vertices!(G, 5289)
add_edge!(G, 93294, 10824)
add_edge!(G, 93294, 11334)
add_edge!(G, 70395, 11334)
add_edge!(G, 92283, 11334)
add_edge!(G, 69731, 11334)
add_edge!(G, 93294, 12322)

gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))

G = Graph()
add_vertices!(G, 6)
add_edge!(G, 1, 2)
add_edge!(G, 1, 3)
add_edge!(G, 4, 3)
add_edge!(G, 4, 5)
add_edge!(G, 5, 2)

gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))

##Test add_edge function
df_simple = DataFrame(C = [1,1,2,3], D = [3,4,4,5])
#add new column with edge assignment ?? DOESNT WORK :(
# df_simple[:E] = add_edge!(G, df_simple.C, df_simple.D)
#try to assign edge between pairs of vertices
for m in 1:length(df_simple)
    for n in 1:nrow(df_simple)
        add_edge!(G, df_simple[m][n])
    end
end

#try to assign values 1:end for each unique ID
df_copy = copy(df_test)
unique(df_test.A) .= 1:4
df_test.A .= 1:nrow(df_copy)


# Create df
df_test = DataFrame(A = [93294, 93294, 70395, 92283, 69731], B = [10824, 11334, 11334, 11334, 12322])
# Sort by ID
sort!(df_test, :A)
# Get unique IDs
unique_ids = unique(df_test.A)
# Create Dict where id => newid
id_dict = Dict(id => indexin(id, unique_ids) for id in df_test.A)
# Add new ids in dataframe
df_test.newcol = [id_dict[id] for id in df_test.A]
df_test

## Repeat for B
# Sort by ID
sort!(df_test, :B)
# Get unique IDs
unique_ids_B = unique(df_test.B)
# Create newids
newids_B = collect(length(unique_ids)+1:length(unique_ids)+length(unique_ids_B))
# Create Dict
id_dict_B = Dict(unique_ids_B[i] => newids_B[i] for i in 1:length(unique_ids_B))
# Add new ids in dataframe
df_test.newcol2 = [id_dict_B[id] for id in df_test.B]
df_test

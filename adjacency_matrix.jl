include("required.jl")

transect

#Create Adjacency Matrix
#create vertices
G = Graph()
add_vertices!(G, 5289)
#assign edges

id_dict = Dict(id => indexin(id, unique_ids) for id in edgelist_T.PredTSN)

for i in 1:length(transect)
    for j in 1:nrow(transect)
        add_edge!(G, transect[i][j])
    end
end


#plot
gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))



# create adjency matrix from edge list


# graph Adjacency matrix
Graph(transect)



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

include("required.jl")

transect

##Create Adjacency matrix
#create matrix of zeros with n = colPred, m = colPrey
M = zeros(Int8, length(unique(transect.newPredID))+1, length(unique(transect.newPreyID))+1)
#assign names for cols
for y in 1:length(unique(transect.newPredID))
    M[y,1] = unique(transect.newPredID)[y]
end
#assign names for rows
for x in 2:length(unique(transect.newPreyID))
    M[1,x] = unique(transect.newPreyID)[x]
end
#Create Adjacency Matrix
for a in 1:unique(transect.newPredID)
    for z in 1:nrow(transect)
        if transect[z,1] == M[a,1]
            for b in 1:unique(transect.newPreyID)
                for c in 1:nrow(transect)
                    if transect[c,1] == M[1,b]
                        M[a,b] = 1
                    else continue
                    end
                end
            end
        end
    end
end

#directed graph
mdg = MetaDiGraph(transect, :newPredID, :newPreyID)



#create vertices
G = ()
add_vertices!(G, 524)

# create an empty undirected graph
g = Graph()
# iterate over the edges
m = 0
for e in edges(g)
    m += 1
end
@assert m == ne(g)



#assign edges
edge_t = add_edge!(i => i for i in transect)

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

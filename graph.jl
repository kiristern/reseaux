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

for i in 1:length(transect)
    for j in 1:nrow(transect)
        add_edge!(G, transect[i][j])
    end
end


#plot
gplot(G, nodelabel=1:nv(G), edgelabel=1:ne(G))


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

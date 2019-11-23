include("required.jl")

transect

##Create Adjacency matrix
#create matrix of zeros with n = colPred, m = colPrey
M = zeros(Int16, length(unique(transect.newPredID))+1, length(unique(transect.newPreyID))+1)
#assign names for cols
    ##doesn't start at 1 in second row....
for y in 2:length(unique(transect.newPredID))+1
    M[y,1] = unique(transect.newPredID)[y-1]
end

#assign names for rows
    ##matrix extends past desired cols?.... keeps updating to original M without replacing old values
for x in 2:length(unique(transect.newPreyID))+1
    M[1,x] = unique(sort!(transect.newPreyID))[x-1]
end

# for a in 1:unique(transect.newPredID)
#     for z in 1:nrow(transect)
#         if transect[z,1] == M[a,1]
#             for b in 1:unique(transect.newPreyID)
#                 for c in 1:nrow(transect)
#                     if transect[c,1] == M[1,b]
#                         M[a,b] = 1
#                     else continue
#                     end
#                 end
#             end
#         end
#     end
# end

# Fill adjacency matrix with ones where there are interactions
u_pred_len = length(unique(transect.newPredID))
pred_len = length(transect.newPredID)
for i in 1:pred_len
    M[transect[i, 1] + 1, transect[i, 2] - u_pred_len  + 1] = 1
end
M

#directed graph
mdg = MetaDiGraph(transect, :newPredID, :newPreyID)


# # Test to make sure the adjacency matrix is correctly filled
# transectTest = [[1,6],[2,7], [3,8], [4,9],[5, 10]]
# MTest = zeros(Int16, 6, 6)
# for y in 2:6
#     MTest[y,1] = transectTest[y-1][1]
# end
#
# for x in 2:6
#     MTest[1,x] = transectTest[x-1][2]
# end
#
# for i in 1:5
#     MTest[i + 1, transectTest[i][2] - 5 + 1] = 1
# end

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

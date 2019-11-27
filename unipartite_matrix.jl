include("../required.jl")

transect

all_ids = vcat(unique(transect.newPredID), unique(transect.newPreyID))

##Create Adjacency matrix
#create n x n matrix of zeros
M = zeros(Int16, (length(unique(transect.newPredID))+length(unique(transect.newPreyID)))+1, (length(unique(transect.newPredID))+length(unique(transect.newPreyID)))+1)
#assign names for cols
for y in 2:length(all_ids)+1
    M[y,1] = all_ids[y-1]
end

#assign names for rows
for x in 2:length(all_ids)+1
    M[1,x] = all_ids[x-1]
end

# Fill adjacency matrix with ones where there are interactions
u_pred_len = length(unique(transect.newPredID))
pred_len = length(transect.newPredID)
for i in 1:length(all_ids)
    M[transect[i, 1] + 1, transect[i, 2] - u_pred_len  + 1] = 1
end
M

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

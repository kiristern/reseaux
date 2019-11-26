include("required.jl")

transect

##Create Adjacency matrix
#create matrix of zeros with n = colPred, m = colPrey
M = zeros(Int16, length(unique(transect.newPredID))+1, length(unique(transect.newPreyID))+1)
#assign names for cols
for y in 2:length(unique(transect.newPredID))+1
    M[y,1] = unique(transect.newPredID)[y-1]
end

#assign names for rows
for x in 2:length(unique(transect.newPreyID))+1
    M[1,x] = unique(sort!(transect.newPreyID))[x-1]
end

# Fill adjacency matrix with ones where there are interactions
u_pred_len = length(unique(transect.newPredID))
pred_len = length(transect.newPredID)
for i in 1:pred_len
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

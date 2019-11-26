include("../required.jl")

# Removing firts row and first column of M matrix to keep only values
M_wrow = M[setdiff(1:end, 1), :]
M_wcol = M_wrow[:, setdiff(1:end, 1)]

# Convert ones and zeros in boolean
M_bool = convert(Array{Bool}, M_wcol .== 1)

# Convert matrix in bipartite network
B = BipartiteNetwork(M_bool)

# Calculate modularity
modules = brim(lp(B)...)
Q(modules...)
Qr(modules...)

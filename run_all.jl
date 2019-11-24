include("required.jl")
include("functions.jl")

###  Load data, Clean and convert data to right types ###
df = CSV.read("WoodEtal_Append1_v2.csv")
edgelist_T = load_data(df, 1)
edgelist_Q = load_data(df, 2)
edgelist_A = load_data(df, 3)
edgelist_L = load_data(df, 4)
edgelist_S = load_data(df, 5)

# Rename IDS to start at 1
keys_T = renameIDs(edgelist_T)
keys_Q = renameIDs(edgelist_Q)
keys_A = renameIDs(edgelist_A)
keys_L = renameIDs(edgelist_L)
keys_S = renameIDs(edgelist_S)

# Compute adjacency matrix
M_T = adjacencyMatrix(keys_T)
M_Q = adjacencyMatrix(keys_Q)
M_A = adjacencyMatrix(keys_A)
M_L = adjacencyMatrix(keys_L)
M_S = adjacencyMatrix(keys_S)

# Compute LP/BRIM
Q_T, Qr_T, B_T = computeModularity(M_T)
Q_Q, Qr_Q, B_Q = computeModularity(M_Q)
Q_A, Qr_A, B_A = computeModularity(M_A)
Q_L, Qr_L, B_L = computeModularity(M_L)
Q_S, Qr_S, B_S = computeModularity(M_S)

# Compute NODF
NODF_T = computeNestedness(B_T)
NODF_Q = computeNestedness(B_Q)
NODF_A = computeNestedness(B_A)
NODF_L = computeNestedness(B_L)
NODF_S = computeNestedness(B_S)

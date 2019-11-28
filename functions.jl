# Function that loads and clean the data into an edgelist
function load_data(df, s)
    # Separate based on WebScale
    scale = [df[df.WebScale .== u,:] for u in unique(df.WebScale)]
    # select for edge interaction columns only
    edgelist = scale[s][:, [:PredTSN, :PreyTSN]]
    # view all entries that contain "san" in PredTSN
    pred_san = edgelist[startswith.(edgelist.PredTSN, "san"),:]
    # remove "san"
    pred_san.PredTSN = replace.(pred_san.PredTSN, "san" .=> "")
    pred_san
    #view unique predID without san
    unique(pred_san,1)
    edgelist.PredTSN == "102" #manually check if in original df
    # remove the "san" from the dataframe itself
    edgelist.PredTSN = replace.(edgelist.PredTSN, "san" .=> "")
    # Do the same for PreyTSN
    backup2 = copy(edgelist)
    old_ids2 = unique(backup2.PreyTSN)
    # keep the indexes before the change
    prey_indexes = startswith.(edgelist.PreyTSN, "san")
    # remove the "san" from the dataframe itself
    edgelist.PreyTSN = replace.(edgelist.PreyTSN, "san" .=> "")
    edgelist
    #check unique preyIDs without san
    check_uniques2 = [in(new_id2, old_ids2) for new_id2 in edgelist.PreyTSN[prey_indexes]]
    filter(isone, check_uniques2)
    # convert "string" to "integer"
    edgelist.PredTSN = parse.(Int64, edgelist.PredTSN)
    edgelist.PreyTSN = parse.(Int64, edgelist.PreyTSN)

    return edgelist
end


# Function that rename the IDs
function renameIDs(edgelist)
    ##Change PredTSN to newID starting from 1
    # Sort by ID
    sort!(edgelist, :PredTSN)
    # Get unique IDs
    unique_ids = unique(edgelist.PredTSN)
    #create new IDs
    newid_pred = collect(1:length(unique_ids))
    # Create Dict where id => newid
    id_dict = Dict(unique_ids[i] => newid_pred[i] for i in 1:length(unique_ids))
    # Add new ids in dataframe
    edgelist.newPredID = [id_dict[id] for id in edgelist.PredTSN]
    ### Do same for prey
    ## Change PreyTSN to new ID starting from end of newPredID
    # Sort by ID
    sort!(edgelist, :PreyTSN)
    # Get unique IDs
    unique_ids_prey = unique(edgelist.PreyTSN)
    # Create new IDs
    newid_prey = collect(length(id_dict)+1:length(id_dict)+length(unique_ids_prey))
    # Create Dict
    id_dict2 = Dict(unique_ids_prey[i] => newid_prey[i] for i in 1:length(unique_ids_prey))
    # Add new ids in dataframe
    edgelist.newPreyID = [id_dict2[id] for id in edgelist.PreyTSN]
    keys = edgelist[:, [:newPredID, :newPreyID]]
    #sort
    sort!(keys, :newPredID)
    #get unique values
    unique!(keys)

    return keys
end


# Function that creates the adjacency matrix
function adjacencyMatrix(keys)
    all_ids = vcat(unique(keys.newPredID), unique(keys.newPreyID))
    ##Create Adjacency matrix
    #create matrix of zeros with n = colPred, m = colPrey
    M = zeros(Int64, length(all_ids)+1, length(all_ids)+1)
    #assign names for cols
    for y in 2:length(all_ids)+1
        M[y,1] = all_ids[y-1]
    end
    #assign names for rows
    for x in 2:length(all_ids)+1
        M[1,x] = all_ids[x-1]
    end
    # Fill adjacency matrix with ones where there are interactions
    for i in 1:length(all_ids)
        M[keys[i, 1] + 1, keys[i, 2] + 1] = 1
    end
    return M
end

# Function that computes the modularity
function computeModularity(M)
    # Removing firts row and first column of M matrix to keep only values
    M_wrow = M[setdiff(1:end, 1), :]
    M_wcol = M_wrow[:, setdiff(1:end, 1)]
    # Convert ones and zeros in boolean
    M_bool = convert(Array{Bool}, M_wcol .== 1)
    # Convert matrix in bipartite network
    B = UnipartiteNetwork(M_bool)
    # Calculate modularity
    modules = brim(lp(B)...)
    return Q(modules...), Qr(modules...), B
end


# Function that cumputes the nestedness
function computeNestedness(B)
    # Calculate nestedness
    return ρ(B)
end

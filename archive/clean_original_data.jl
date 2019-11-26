include("../required.jl")

#import data
df = CSV.read("WoodEtal_Append1_v2.csv")

# Separate based on WebScale
scale = [df[df.WebScale .== u,:] for u in unique(df.WebScale)]
scale2 = [scale[5][scale[5].WebID .== j,:] for j in unique(scale[5].WebID)]

#notes which scale[x] = scale 
#scale[1] = T
#scale[2] = Q
#scale[3] = A
#scale[4] = L
#scale[5] = S

# select for edge interaction columns only
edgelist_T = scale[1][:, [:PredTSN, :PreyTSN]]

# view all entries that contain "san" in PredTSN
pred_san = edgelist_T[startswith.(edgelist_T.PredTSN, "san"),:]
# remove "san"
pred_san.PredTSN = replace.(pred_san.PredTSN, "san" .=> "")
pred_san
#view unique predID without san
unique(pred_san,1)
edgelist_T.PredTSN == "102" #manually check if in original df

# # alternative
# backup = copy(edgelist_T)
# old_ids = unique(backup.PredTSN)
# # keep the indexes before the change
# pred_indexes = startswith.(edgelist_T.PredTSN, "san")
#
# # remove the "san" from the dataframe itself
 edgelist_T.PredTSN = replace.(edgelist_T.PredTSN, "san" .=> "")
#
# #view unique preyIDs without san (make sure they are not repeated in original)
# check_uniques = [in(new_id, old_ids) for new_id in edgelist_T.PredTSN[pred_indexes]]
# filter(isone, check_uniques)

### Do the same for PreyTSN
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

edgelist_T

# convert "string" to "integer"
edgelist_T.PredTSN = parse.(Int64, edgelist_T.PredTSN)
edgelist_T.PreyTSN = parse.(Int64, edgelist_T.PreyTSN)

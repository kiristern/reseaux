# reseaux

Identifying network modularity and nestedness at different spatial scales

## How to install dependencies
In the Julia/Juno console (REPL)

```
julia> import Pkg
julia> Pkg.add("GraphDataFrameBridge")
```

## Running the code
1. Run the *clean_original_data.jl* Julia script
It cleans and formats the data in a usable way.
2. Run the *rename_IDs.jl* Julia script
The IDs of the prey/preds were too big. This script makes them start at 1.
3. Run the *adjacency_matrix.jl* Julia script
Processes the adjacency matrix for prey/preds.

## Clearing the workspace
To erase the registered variables and start a new workspace type:
```
CTRL+J CTRL+K
```

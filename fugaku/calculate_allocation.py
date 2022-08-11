from math import floor

ranks_per_node = 8
ref_res = 639
ref_nnodes = 1

constant = ref_res**2/ref_nnodes

for res in [639, 1279, 1999, 2559, 3999, 7999, 15999, 159999]:
    nnodes = max(1,floor(res**2/constant))
    wavenums_per_rank = int((res + 1)/(nnodes * 8))
    print(f"Use ~{nnodes:5d} nodes for TCo{res} (~{wavenums_per_rank} wavenumbers per rank)")
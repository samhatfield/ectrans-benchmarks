from math import ceil

ranks_per_node = 16
ref_res = 639
ref_nmpi = 32

constant = (ref_res+1)**2/ref_nmpi

for res in [319, 639, 1279, 1999, 2559, 3999, 7999, 15999, 159999]:
    nmpi = max(1,ceil((res+1)**2/constant))
    wavenums_per_rank = int((res + 1)/nmpi)
    print(f"Use ~{nmpi:5d} ranks ({ceil(nmpi/ranks_per_node)} nodes) for TCo{res}" +
           " (~{wavenums_per_rank} wavenumbers per rank)")

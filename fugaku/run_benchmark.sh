# Benchmark script for ecTrans
# This performs a single benchmark of 10 iterations on Fugaku at the user-given resolution

if [ $# -lt 2 ]; then
    echo "run_benchmark.sh truncation num_nodes"
    echo "e.g. ./run_benchmark.sh 79 1"
    exit 1
fi

res=$1
nnodes=$2

# Make directory for storing benchmark results, if it doesn't already exist
mkdir -p outdir

bindir=/vol0004/share/ra000005/user/hatfield/ectrans/build/bin
benchmark_bin=ectrans-benchmark-sp

jobfile=ectrans_benchmark.pjm

# Set number of OpenMP threads per rank and number of MPI ranks per node (6x8 is optimal)
nomp_per_rank=6
nmpi_per_node=8

# Calculate the total number of MPI ranks
nmpi=$((nmpi_per_node * nnodes))

# Create job script
cat <<EOF > $jobfile
#!/bin/bash --login

#PJM -L "node=$nnodes"
#PJM -L "elapse=60:00"
#PJM --mpi "max-proc-per-node=$nmpi_per_node"
#PJM --mpi "rank-map-bychip"

set -eux

module load lang/tcsds-1.2.35

# Turn on MPI
export ECTRANS_USE_MPI=1

# Define output file for stdout and stderr of MPI invocation
output="outdir/tco${res}_benchmark.${nnodes}x${nmpi_per_node}x${nomp_per_rank}.\${PJM_JOBID}.out"

OMP_NUM_THREADS=$nomp_per_rank mpiexec -n $nmpi -std \$output $bindir/$benchmark_bin -n 10 -t $res
EOF

pjsub $jobfile
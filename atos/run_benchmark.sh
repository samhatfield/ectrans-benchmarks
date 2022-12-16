# Benchmark script for ecTrans
# This performs a single benchmark of 10 iterations on Atos at the user-given resolution

if [ $# -lt 2 ]; then
    echo "run_benchmark.sh truncation num_mpi_ranks"
    echo "e.g. ./run_benchmark.sh 79 1"
    exit 1
fi

res=$1
nmpi=$2

# Make directory for storing benchmark results, if it doesn't already exist
mkdir -p outdir

bundledir=/ec/res4/hpcperm/nash/ectrans-bundle
bindir=$bundledir/build/bin
benchmark_bin=ectrans-benchmark-sp


# Set number of OpenMP threads per rank and number of MPI ranks per node (6x8 is optimal)
nomp_per_rank=8
nmpi_per_node=16

# Calculate number of nodes
nnodes=$((nmpi / nmpi_per_node))
nnodes=$((nnodes < 1 ? 1 : nnodes))

jobfile=ectrans_benchmark.${res}.${nnodes}.slurm

# Create job script
cat <<EOF > $jobfile
#!/bin/bash --login

#SBATCH -p par
#SBATCH --nodes=$nnodes
#SBATCH --time=60:00
#SBATCH --ntasks-per-node=$nmpi_per_node
#SBATCH --cpus-per-task=$nomp_per_rank
#SBATCH -o outdir/tco${res}_benchmark.${nnodes}x${nmpi_per_node}x${nomp_per_rank}.%j.out
#SBATCH --job-name ${res}_benchmark

set -eux

source $bundledir/arch/ecmwf/atos/intel/2021.4.0/env.sh

OMP_NUM_THREADS=$nomp_per_rank srun -n $nmpi $bindir/$benchmark_bin --niter 10 --truncation $res --nlev 137
EOF

sbatch $jobfile

#!/bin/sh

# Run as qsub -v ncpus=integer script

ncpus

STDOUT="ncpus${ncpus}.stdout"
STDERR="ncpus${ncpus}.stderr"

#Job parameters:
#PBS -l select=1:ncpus=${ncpus}:mem=1G 
#PBS -l walltime=01:00:00
##PBS -q med-bio 
#PBS -V

#Save standard error and out to files:
#PBS -e $STDOUT
#PBS -o $STDERR

#Module commands:
#source activate python27_env

# Define bash variables for job:
#INFILE="airwave_b37"
#OUTFILE="airwave_b37"

BASE_DIR="/home/aberlang/bin/ruffus_and_drmaa.dir/"

# Commands:
echo "Number of cpus:" $ncpus

which python
python --version
which R

echo 'Test with full path:'
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}drmaa_status.py
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}ruffus_test.py


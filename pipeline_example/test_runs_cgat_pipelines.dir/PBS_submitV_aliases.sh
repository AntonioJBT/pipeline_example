#!/bin/sh

# Run as qsub -v ncpus=integer script

#Job parameters:
#PBS -l select=1:ncpus=12:mem=1G 
#PBS -l walltime=00:10:00
##PBS -q med-bio 
#PBS -V

#Save standard error and out to files:
#PBS -e pass_aliases.stderr
#PBS -o pass_aliases.stdout

#Module commands:
#source activate python27_env

# Define bash variables for job:
BASE_DIR="/home/aberlang/bin/ruffus_and_drmaa.dir/"

# Commands:

#source $HOME/.bashrc
which MarkDuplicates
which picard

which python
python --version
which R

echo 'Test with full path:'
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}drmaa_status.py
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}ruffus_test.py


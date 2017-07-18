#!/bin/sh

#Job parameters:
#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=16:mem=1gb
#PBS -q med-bio 
##PBS -V

#Save standard error and out to files:
#PBS -e stderr_noPBS-V_source_in_PBS.file
#PBS -o stdout_noPBS-V_source_in_PBS.file

#Module commands:
source activate python27_env

# Define bash variables for job:
#INFILE="airwave_b37"
#OUTFILE="airwave_b37"

#File management:
#cp $PBS_O_WORKDIR/$INFILE $TMPDIR
#cp $PBS_O_WORKDIR/$SAMPLE_IDs $TMPDIR
#cp $PBS_O_WORKDIR/$CONFIG $TMPDIR
BASE_DIR="/export131/home/aberlang/bin/ruffus_and_drmaa.dir/"
SCRIPTS_DIR=""
SCRIPTS_DIR=""

#Command:
which python
python --version
which R

echo 'Test with full path:'
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}drmaa_status.py
/export131/home/aberlang/bin/miniconda3/envs/python27_env/bin/python ${BASE_DIR}ruffus_test.py

# This errors as drmaa and ruffus can't be found:
echo 'Test without full path:'
which python
python --version
which R

python ${BASE_DIR}drmaa_status.py
python ${BASE_DIR}ruffus_test.py

#Notify by email:
##PBS -m abe


#File management:
#cp $OUTFILE* $PBS_O_WORKDIR

#!/bin/sh

#Job parameters:
#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=8:mem=1gb
##PBS -q med-bio 
#PBS -V

#Save standard error and out to files:
##PBS -e stderr_noPBS-V_source_in_PBS.file
##PBS -o stdout_noPBS-V_source_in_PBS.file

#Module commands:
#source activate python27_env

# Define bash variables for job:
#scripts_dir=${1}

#File management:
#cp $PBS_O_WORKDIR/$INFILE $TMPDIR

#Commands to run:
which python
python --version
which R
R --version

#echo 'Test with full path:'
#python ${scripts_dir}/drmaa_status.py
#python ${scripts_dir}/ruffus_test.py

#File management:
#cp $OUTFILE* $PBS_O_WORKDIR

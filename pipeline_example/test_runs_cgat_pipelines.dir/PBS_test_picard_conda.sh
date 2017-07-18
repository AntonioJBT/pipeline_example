#!/bin/sh

# Run as qsub -v ncpus=integer script

#Job parameters:
#PBS -l select=1:ncpus=12:mem=1G 
#PBS -l walltime=00:10:00
##PBS -q med-bio 
##PBS -V

#Save standard error and out to files:
#PBS -e pass_picard_conda_2.stderr
#PBS -o pass_picard_conda_2.stdout

#Module commands:
source activate python27_env
#module load picard/2.6.0

# Define bash variables for job:
BASE_DIR="/export131/home/aberlang/bin/ruffus_and_drmaa.dir/test_runs_cgat_pipelines.dir/mapping.dir"

# Commands:

#source $HOME/.bashrc
which MarkDuplicates
which picard

MarkDuplicates     INPUT=${BASE_DIR}/bwa.dir/SRR062634.bwa.bam     ASSUME_SORTED=true     METRICS_FILE=${BASE_DIR}/bwa.dir/SRR062634.bwa.picard_duplication_metrics     OUTPUT=/dev/null     VALIDATION_STRINGENCY=SILENT


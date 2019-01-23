#!/bin/bash

# Run as eg:
# bash run_all_drmaa_examples.sh scripts_dir
# scripts_dir must be the full path

set -e

out_dir=all_drmaa_examples
scripts_dir=${1}

#DIR_OUT="results_ruffus_module.dir/"
#DIR_OUT="results_miniconda_no_bashrc.dir/"

echo 'Creating output directory'
mkdir ${out_dir}
cd ${out_dir}

# drmaa status and tests:
python ${scripts_dir}/drmaa_status.py &> drmaa_status.out
python ${scripts_dir}/drmaa_example.py /bin/sleep 3 &> example.out
python ${scripts_dir}/drmaa_example1.py &> example1.out
python ${scripts_dir}/drmaa_example1.1.py &> example1.1.out
python ${scripts_dir}/drmaa_example2.py &> example2.out
python ${scripts_dir}/drmaa_example2.1.py &> example2.1.out
python ${scripts_dir}/drmaa_example3.py &> example3.out
python ${scripts_dir}/drmaa_example3.1.py &> example3.1.out
python ${scripts_dir}/drmaa_example3.2.py &> example3.2.out
python ${scripts_dir}/drmaa_example4.py &> example4.out
python ${scripts_dir}/drmaa_example5.py &> example5.out
python ${scripts_dir}/drmaa_example6.py &> example6.out

# Other tests to run:
python ${scripts_dir}/PBS_ruffus_drmaa_test.sh &> PBS_ruffus_drmaa_test.out
python ${scripts_dir}/ruffus_C1_intro.py &> ruffus_C1_intro.out
python ${scripts_dir}/ruffus_test_with_drmaa.py &> ruffus_test_with_drmaa.out
python ${scripts_dir}/ruffus_test_2_with_drmaa.py &> ruffus_test_2_with_drmaa.out
python ${scripts_dir}/PBS_ruffus_drmaa_test.sh &> PBS_ruffus_drmaa_test.out

cd ..

echo 'Finished running.'
echo 'Output files in'
echo ${out_dir}
echo 'Logs of output are in example.out'

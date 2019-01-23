#!/bin/bash

# Run as eg:
# bash run_all_drmaa_examples.sh scripts_dir

set -e

out_dir=all_drmaa_examples
scripts_dir=${1}

#DIR_OUT="results_ruffus_module.dir/"
#DIR_OUT="results_miniconda_no_bashrc.dir/"

echo 'Creating output directory'
mkdir ${out_dir}
cd ${out_dir}

python ${scripts_dir}/example.py /bin/sleep 3 &> example.out
python ${scripts_dir}/example1.1.py &> example1.1.out
python ${scripts_dir}/example1.py &> example1.out
python ${scripts_dir}/example2.1.py &> example2.1.out
python ${scripts_dir}/example2.py &> example2.out
python ${scripts_dir}/example3.1.py &> example3.1.out
python ${scripts_dir}/example3.2.py &> example3.2.out
python ${scripts_dir}/example3.py &> example3.out
python ${scripts_dir}/example4.py &> example4.out
python ${scripts_dir}/example5.py &> example5.out
python ${scripts_dir}/example6.py &> example6.out

cd ..

echo 'Finished running.'
echo 'Output files in'
echo ${out_dir}
echo 'Logs of output are in example.out'

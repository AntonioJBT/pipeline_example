#!/bin/bash
set -e 

#DIR_OUT="results_ruffus_module.dir/"
#DIR_OUT="results_miniconda_no_bashrc.dir/"

mkdir $1

python example.py /bin/sleep 3 &> example.out
python example1.1.py &> example1.1.out
python example1.py &> example1.out
python example2.1.py &> example2.1.out
python example2.py &> example2.out
python example3.1.py &> example3.1.out
python example3.2.py &> example3.2.out
python example3.py &> example3.out
python example4.py &> example4.out
python example5.py &> example5.out
python example6.py &> example6.out

mv none.* $1
mv *out $1


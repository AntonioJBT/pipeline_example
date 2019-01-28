.. copy across your travis "build..." logo so that it appears in your Github page

.. .. image:: https://travis-ci.org/AntonioJBT/pipeline_example.svg?branch=master
    :target: https://travis-ci.org/AntonioJBT/pipeline_example

.. do the same for ReadtheDocs image:

.. .. image:: https://readthedocs.org/projects/pipeline_example/badge/?version=latest
    :target: http://pipeline_example.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

.. Zenodo gives a number instead, this needs to be put in manually here:
.. .. image:: https://zenodo.org/badge/#######.svg
    :target: https://zenodo.org/badge/latestdoi/#####

################################################
pipeline_example
################################################

A repo to keep tests for drmaa, ruffus and cgat-core.

Scripts and examples are from the relevant packages. For drmaa, only PBSPro has examples.

You can see further examples of pipelines and some installation instructions in cgat-core_ and `project_quickstart`_.

.. _`project_quickstart`: https://github.com/AntonioJBT/project_quickstart


Requirements
-------------

* Ruffus_
* cgat-core_
* python-drmaa_
* and your HPC-specific DRMAA_ such as `PBSPro/Torque`_

.. code-block::

    conda install cgat-core

Hopefully that's all you need for Ruffus, cgat-core and python-drmaa. Best to check instructions for each tool however. For DRMAA you'll very likely need to liaise with your system's administrator.

Note that currently conda-forge has "drmaa" v0.7.9 and "python-drmaa" v0.7.6

The folder Docker_and_config_file_examples contains examples of PBSPro user and system wide settings. Note that Dockerfiles will not work per se but have installation instructions for older versions of requirements.

An updated version with a pipeline example is available, follow the `cgat-core docs`_.

.. _Ruffus: http://www.ruffus.org.uk/
.. _cgat-core: https://github.com/cgat-developers/cgat-core
.. _python-drmaa: https://drmaa-python.readthedocs.io/en/latest/
.. _DRMAA: https://www.drmaa.org/
.. _`PBSPro/Torque`: http://apps.man.poznan.pl/trac/pbs-drmaa
.. _`cgat-core docs`: https://cgat-core.readthedocs.io/en/latest/getting_started/Examples.html

Note that once the system DRMAA library is installed, you'll need to set an environment variable::

    export DRMAA_LIBRARY_PATH=/<full-path>/libdrmaa.so
    # such as:
    export DRMAA_LIBRARY_PATH=/usr/local/lib/libdrmaa.so.1
    

Installation and usage
----------------------

Create a testing directory and clone from GitHub:

.. code::
    
    mkdir test_cgat_drmaa
    cd test_cgat_drmaa
    git clone https://github.com/AntonioJBT/pipeline_example.git

Test whether programs are running as expected for ruffus, ruffus with drmaa, and cgatcore:

(this is incomplete...)

.. code::

    # Check ruffus:
    python pipeline_example/pipeline_example/ruffus_and_drmaa_tests/ruffus_C1_intro.py
    
    # Check drmaa:
    python pipeline_example/pipeline_example/ruffus_and_drmaa_tests/drmaa_status.py
    python pipeline_example/pipeline_example/ruffus_and_drmaa_tests/drmaa_example1.py
    
    # Ruffus and drmaa:
    #python pipeline_example/pipeline_example/ruffus_and_drmaa_tests/chapter14_ruffus_drmaa.py

    # A standard PBSPro qsub script (your system may be different):
    qsub pipeline_example/pipeline_example/ruffus_and_drmaa_tests/standard_PBS_qsub.sh
    qstat
    # Then check the standard out and error files

    # Check a cgat-core pipeline:
    python pipeline_example/pipeline_example/pipeline_example_minimal.py --help    
    ln -s pipeline_example/pipeline_example/pipeline_example_minimal.yml .
    # (the previous command would usually use the cgat-core config option)
    python pipeline_example/pipeline_example/pipeline_example_minimal.py show full
    python pipeline_example/pipeline_example/pipeline_example_minimal.py printconfig

    # Run locally:
    python pipeline_example/pipeline_example/pipeline_example_minimal.py make full --local
    # Check the outputs, eg:
    cat pipeline_example_minimal.counts
    sqlite3 csvdb
    # within sqlite3 do eg:
    sqlite> .tables ;
    sqlite> SELECT * FROM pipeline_example_minimal_counts;
    sqlite> .exit

    # On the cluster (you need to setup the appropriate configuration for your cluster):
    # Clean up previous test:
    rm -rf pipeline.log pipeline_example_minimal_counts.load csvdb pipeline_example_minimal.counts
    # Run on the cluster, scripts are short but you may still want to nohup it:
    nohup python pipeline_example/pipeline_example/pipeline_example_minimal.py make full &
    tail -f nohup.out
    # Check the outputs


Further references and example data for a CGAT pipeline
----------------------------------------------------------

See first the tutorials for cgat-flow (here__) and `cgat-core pipeline example`_.

.. __: https://www.cgat.org/downloads/public/cgatpipelines/documentation/Tutorials.html
.. _`cgat-core pipeline example`: https://cgat-core.readthedocs.io/en/latest/getting_started/Tutorial.html

Some data locations can be found here, for more see cgat-flow's `documentation <https://www.cgat.org/downloads/public/cgatpipelines/documentation/>`_.

Example data
=============

# 201PH are ChIP-seq files from:

ftp://ftp.broad.mit.edu/pub/papers/chipseq/Ku2008/raw/

# Other ChIP-seq files are from here__ (see `this link`__):

- SRR446027_1.fastq.gz
- SRR446027_2.fastq.gz

.. _cgat-flow: https://github.com/cgat-developers/cgat-flow
.. __: https://github.com/tgirke/systemPipeRdata/tree/master/inst/extdata/fastq
.. __: http://biocluster.ucr.edu/~rkaundal/workshops/R_feb2016/ChIPseq/ChIPseq.html


Further references
======================

cgat-flow_, a set of ruffus based pipelines.

`Chapter 14: Multiprocessing, drmaa and Computation Clusters — ruffus 2.6.3 documentation`_

.. _`Chapter 14: Multiprocessing, drmaa and Computation Clusters — ruffus 2.6.3 documentation`: http://www.ruffus.org.uk/tutorials/new_tutorial/multiprocessing.html

`Connecting to a Cluster — Galaxy Project 19.05.dev documentation`_

.. _`Connecting to a Cluster — Galaxy Project 19.05.dev documentation`: https://docs.galaxyproject.org/en/latest/admin/cluster.html

`DRMAA Wikipedia page`_

.. _`DRMAA Wikipedia page`: https://en.wikipedia.org/wiki/DRMAA

Contribute
----------

Please raise any issues or pull requests in the `issue tracker`_.

.. _`issue tracker`: github.com/AntonioJBT/pipeline_example/issues


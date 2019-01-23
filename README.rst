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

To use
------

Test whether programs are running as expected for ruffus, ruffus with drmaa, and cgatcore.

.. code::

    TO DO

Requirements
-------------

* Ruffus_
* cgat-core_
* python-drmaa_
* and your HPC-specific DRMAA such as `PBSPro/Torque`_

You'll need to check instructions for each tool separately. For DRMAA you'll very likely need to liaise with your system's administrator.

Note that Dockerfiles will not work per se but have installation instructions for older versions of requirements.

The folder config_files contains examples of PBSPro user and system wide settings.

Note that an updated version with a pipeline example is available, follow the `cgat-core docs`_.

.. _Ruffus: http://www.ruffus.org.uk/
.. _cgat-core: https://github.com/cgat-developers/cgat-core
.. _python-drmaa: https://drmaa-python.readthedocs.io/en/latest/
.. _DRMAA: https://en.wikipedia.org/wiki/DRMAA
.. _`PBSPro/Torque`: http://apps.man.poznan.pl/trac/pbs-drmaa
.. _`cgat-core docs`: https://cgat-core.readthedocs.io/en/latest/getting_started/Examples.html

Note that once the system DRMAA library is installed, you'll need to set an environment variable::
    
    export DRMAA_LIBRARY_PATH=/<full-path>/libdrmaa.so
    # such as:
    export DRMAA_LIBRARY_PATH=/usr/local/lib/libdrmaa.so.1
    
    

Installation
------------

Clone from GitHub:

.. code::
    
    git clone https://github.com/AntonioJBT/pipelien_example.git

Note that Dockerfiles will not work per se but have installation instructions.

Contribute
----------

Please raise any issues or pull requests in the `issue tracker`_.

.. _`issue tracker`: github.com/AntonioJBT/pipeline_example/issues


Further references
--------------------

`Chapter 14: Multiprocessing, drmaa and Computation Clusters — ruffus 2.6.3 documentation`_

.. _`Chapter 14: Multiprocessing, drmaa and Computation Clusters — ruffus 2.6.3 documentation`: http://www.ruffus.org.uk/tutorials/new_tutorial/multiprocessing.html

`Connecting to a Cluster — Galaxy Project 19.05.dev documentation`_

.. _`Connecting to a Cluster — Galaxy Project 19.05.dev documentation`: https://docs.galaxyproject.org/en/latest/admin/cluster.html

cgat-flow_, a set of ruffus based pipelines.

Example data for a CGAT pipeline
-----------------------------------

Some data locations here, for more see cgat-flow_ and its `documentation <https://www.cgat.org/downloads/public/cgatpipelines/documentation/>`_.

cgat-flow_ tutorial::

    wget https://www.cgat.org/downloads/public/cgatpipelines/Tutorial_data/tutorial_fastq.tar.gz

# 201PH are ChIP-seq files from:

ftp://ftp.broad.mit.edu/pub/papers/chipseq/Ku2008/raw/

# Other ChIP-seq files are from here__ (see `this link`__):

- SRR446027_1.fastq.gz
- SRR446027_2.fastq.gz

.. _cgat-flow: https://github.com/cgat-developers/cgat-flow
.. __: https://github.com/tgirke/systemPipeRdata/tree/master/inst/extdata/fastq
.. __: http://biocluster.ucr.edu/~rkaundal/workshops/R_feb2016/ChIPseq/ChIPseq.html


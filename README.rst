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
Scripts and examples are from the relevant packages.
For drmaa only PBSPro has examples.
This is rather incomplete.
You can see further examples and some installation instructions for cgat-core_ in `project_quickstart`_.

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

.. _Ruffus: http://www.ruffus.org.uk/
.. _cgat-core: https://github.com/cgat-developers/cgat-core
.. _python-drmaa: https://drmaa-python.readthedocs.io/en/latest/
.. _DRMAA: https://en.wikipedia.org/wiki/DRMAA
.. _`PBSPro/Torque`: http://apps.man.poznan.pl/trac/pbs-drmaa


Installation
------------

Clone from GitHub:

.. code::
    
    git clone https://github.com/AntonioJBT/pipelien_example.git

Contribute
----------

Please raise any issues or pull requests in the `issue tracker`_.

.. _`issue tracker`: github.com/AntonioJBT/pipeline_example/issues



'''
pipeline_name
=============

:Author: |author_name|
:Release: |version|
:Date: |today|


Overview
========

|long_description|


Purpose
=======

.. briefly describe the main purpose and methods of the pipeline


Usage and options
=================

These are based on docopt_, see examples_.

.. _docopt: https://github.com/docopt/docopt

.. _examples: https://github.com/docopt/docopt/blob/master/examples/options_example.py


Usage:
       pipeline_name [--main-method]
       pipeline_name [-I FILE]
       pipeline_name [-O FILE]
       pipeline_name [-h | --help]
       pipeline_name [-V | --version]
       pipeline_name [-f --force]
       pipeline_name [-L | --log]

Options:
    -I             Input file name.
    -O             Output file name.
    -h --help      Show this screen
    -V --version   Show version
    -f --force     Force overwrite
    -L --log       Log file name.


Configuration
=============

This pipeline is built using a Ruffus/CGAT approach. You need to have Python, Ruffus, CGAT core tools and any other specific dependencies needed fo this script.

A configuration file was created at the same time as this script
(pipeline_template.yml).
Use this to extract any arbitrary parameters that could be changed in future
re-runs of the pipeline.


Input files
===========

.. Describe the input files needed, urls for reference and preferably place
example data somewhere.


Pipeline output
===============

.. Describe output files and results


Requirements
============

CGATPipelines core setup, Ruffus as well as the following
software to be in the path:

.. Add any additional external requirements such as 3rd party software
   or R modules below:

Requirements:

* R >= 1.1
*

Documentation
=============

    For more information see:

        |url|

'''

from ruffus import *

import sys
import os
import sqlite3

import cgatcore.experiment as E
from cgatcore import pipeline as P
import cgatcore.iotools as iotools

# load options from the config file
PARAMS = P.get_parameters(
        ["%s/pipeline.yml" % os.path.splitext(__file__)[0],
            "../pipeline.yml",
            "pipeline.yml"])

# -----------------------------------------------
# Utility functions
def connect():
    '''utility function to connect to database.

    Use this method to connect to the pipeline database.
    Additional databases can be attached here as well.

    Returns an sqlite3 database handle.
    '''

    dbh = sqlite3.connect(PARAMS["database_name"])
    statement = '''ATTACH DATABASE '%s' as annotations''' % (
        PARAMS["annotations_database"])
    cc = dbh.cursor()
    cc.execute(statement)
    cc.close()

    return dbh


# ---------------------------------------------------
# Specific pipeline tasks
# Run CGAT pipeline_quickstart.py template functions:

@transform(("*.yml"),
           regex("(.*)\.(.*)"),
           r"\1.counts")
def countWords(infile, outfile):
    '''count the number of words in the pipeline configuration files.
       This function is a copy of pipeline_quickstart.py at CGAT'''

    # the command line statement we want to execute
    statement = '''awk 'BEGIN { printf("word\\tfreq\\n"); }
    {for (i = 1; i <= NF; i++) freq[$i]++}
    END { for (word in freq) printf "%%s\\t%%d\\n", word, freq[word] }'
    < %(infile)s > %(outfile)s'''

    # execute command in variable statement.
    # The command will be sent to the cluster (by default, but this can be
    # turned off with --local).  The statement will be
    # interpolated with any options that are defined in in the
    # configuration files or variable that are declared in the calling
    # function.  For example, %(infile)s will we substituted with the
    # contents of the variable "infile".
    P.run()


@transform(countWords,
           suffix(".counts"),
           "_counts.load")
def loadWordCounts(infile, outfile):
    '''load results of word counting into database.'''
    P.load(infile, outfile, "--add-index=word")


# ---------------------------------------------------
# Tasks to test Ruffus
# not run at the moment, add to task full() if needed

@mkdir('ruffus_C1_results')
def testRuffus(outfile):
    ''' Runs the script a simple Ruffus test see:
        http://www.ruffus.org.uk/tutorials/new_tutorial/introduction.html
    '''

    # the command line statement we want to execute
    statement = ''' cd ruffus_C1_results;
                    checkpoint;
                    python ruffus_C1_intro.py '''

    P.run()

@follows(testRuffus)
def testRuffusWithDrmaa():
    ''' Runs two scripts to test Ruffus and drmaa libraries
    '''

    statement = ''' echo 'Test without full path:';
                    checkpoint;
                    which python;
                    checkpoint;
                    python --version;
                    checkpoint;
                    which R;
                    checkpoint
                '''

    statement = ''' python ruffus_test_with_drmaa.py
                '''

    statement = ''' python ruffus_test_2_with_drmaa.py
                '''

    P.run()

def testDrmaa(outdir):
    ''' Runs the drmaa package example scripts to test installation, see:
        https://github.com/pygridtools/drmaa-python
    '''

    statement = ''' ./run_all_drmaa_examples.sh drmaa_tests
                '''
    P.run()


# ---------------------------------------------------
# Generic pipeline tasks
@follows(loadWordCounts)
def full():
    pass


#def build_report():
#    '''build report from scratch.
#
#    Any existing report will be overwritten.
#    '''

#    E.info("starting report build process from scratch")
#    P.run_report(clean=True)

# Finish and exit:
if __name__ == '__main__':
    sys.exit(P.main(sys.argv))

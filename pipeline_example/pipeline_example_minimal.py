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
(pipeline_template.ini).
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
import shutil
import subprocess

# TO DO: check CGAT_core and how to import here:
#import CGAT.Experiment as E
import CGATPipelines.Pipeline as P
import CGATPipelines.Pipeline as P

# load options from the config file
PARAMS = P.getParameters(
    ["%s/pipeline.ini" % os.path.splitext(__file__)[0],
     "../pipeline.ini",
     "pipeline.ini"])

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

@transform(("pipeline.ini"),
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

@follows(countWords)
@transform(countWords,
           suffix(".counts"),
           "_counts.load")
def loadWordCounts(infile, outfile):
    '''load results of word counting into database.'''
    P.load(infile, outfile, "--add-index=word")


# ---------------------------------------------------
# Tasks to test Ruffus

@mkdir('ruffus_C1_results')
def testRuffus(outfile):
    ''' Runs the script a simple Ruffus test with BLAST see:
        http://www.ruffus.org.uk/tutorials/new_tutorial/introduction.html
    '''

    # the command line statement we want to execute
    statement = ''' cd ruffus_C1_results;
                    checkpoint;
                    python ruffus_C1_intro.py '''

    P.run()

@follows(testRuffus)
def checkDependencies():
    ''' Runs C2 Ruffus manual BLAST example pipeline:
        http://www.ruffus.org.uk/examples/bioinformatics/index.html
        You need blastall and formatdb installed. You can get these here:
        https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download
        Or use conda to install blast+ which includes the above:
        https://anaconda.org/biocore/blast-plus
    '''

    # Check conda and blast+ are installed, otherwise exit for conda and
    # install for blast+:
    if not str('conda') in shutil.which('conda'):
        E.info('Exiting, conda not installed')
        sys.exit()
    elif str('conda') in shutil.which('conda'):
        E.info('conda installed')
    if not str('blastp') in shutil.which('blastp'):
        try:
            subprocess.run('conda install -c biococonda blast', shell=True, check=True)
        except OSError:
            E.info('conda failed to install blast try manually.')
            sys.exit()
    if not str('makeblastdb') in shutil.which('makeblastdb'):
        E.info('conda failed to install blast try manually.')
        sys.exit()

    # Print out some basic info to the log file:
    statement = ''' echo 'Test without full path:';
                    checkpoint;
                    which python;
                    checkpoint;
                    python --version;
                    checkpoint;
                    which R;
                    checkpoint;
                '''
    P.run()

@follows(checkDependencies)
def getFasta():
    ''' Download a protein fasta file and copy some of its lines for searching
    '''

    # Download the human refseq sequence file and format the ncbi database:
    statement = ''' wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.1.protein.faa.gz :
                    checkpoint;
                    gunzip human.1.protein.faa.gz;
                    checkpoint;
                    sed -n '2p;10p;20p;40p;50p' human.1.protein.faa > original.fa;
                    checkpoint;
                '''
    P.run()



# The following is just copied from Ruffus:
# http://www.ruffus.org.uk/examples/bioinformatics/part1_code.html#examples-bioinformatics-part1-code
# but modified for the CGAT Pipeline module
original_fasta = "original.fa"
database_file  = "human.1.protein.faa"

@follows(getFasta)
@split(original_fasta, "*.segment")
def splitFasta (seqFile, segments):
    """Split sequence file into
       as many fragments as appropriate
       depending on the size of original_fasta"""
    current_file_index = 0
    for line in open(original_fasta):
        #
        # start a new file for each accession line
        #
        if line[0] == '>':
            current_file_index += 1
            current_file = open("%d.segment" % current_file_index, "w")
        current_file.write(line)

@follows(splitFasta)
@transform(splitFasta, suffix(".segment"), ".blastResult")
def runBlast(seqFile,  blastResultFile):
    """Run blast"""
    os.system("blastp -d %s -i %s > %s" %
                (database_file, seqFile, blastResultFile))


@follows(runBlast)
@merge(runBlast, "final.blast_results")
def combineBlastResults (blastResultFiles, combinedBlastResultFile):
    """Combine blast results"""
    output_file = open(combinedBlastResultFile,  "w")
    for i in blastResultFiles:
        output_file.write(open(i).read())

# ---------------------------------------------------
# Generic pipeline tasks
@follows(countWords,
        combineBlastResults)
def full():
    pass


#def build_report():
#    '''build report from scratch.
#
#    Any existing report will be overwritten.
#    '''

#    E.info("starting report build process from scratch")
#    P.run_report(clean=True)

# Finish and exit with docopt arguments:
#if __name__ == '__main__':
#    arguments = docopt(__doc__, version='xxx 0.1')
#    print(arguments)
#    sys.exit(P.main(sys.argv)) # This is because of CGATPipeline.Pipeline,
                               # otherwise sys.exit(main))

if __name__ == "__main__":
    sys.exit(P.main(sys.argv))

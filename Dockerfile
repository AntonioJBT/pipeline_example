##################################################
# Dockerfile for pipeline_example 
# https://github.com/AntonioJBT/pipeline_example
##################################################


############
# Base image
############

# FROM continuumio/miniconda # probably OK but needs dependencies sorting out
# and maybe conflicts with Requirements.py
# FROM continuumio/anaconda # works
# FROM continuumio/anaconda3

# FROM jfloff/alpine-python:2.7
# FROM jfloff/alpine-python
# https://github.com/jfloff/alpine-python
# This is a minimal Python 3 image that can start from python or bash

FROM continuumio/miniconda3

# Or simply run:
# docker run --rm -ti jfloff/alpine-python bash
# docker run --rm -ti jfloff/alpine-python python hello.py

#########
# Contact
#########
MAINTAINER Antonio Berlanga-Taylor <a.berlanga@imperial.ac.uk>


#########################
# Update/install packages
#########################

# Install system dependencies

# For anaconda/miniconda:
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    fixincludes \
    unzip \
    vim

RUN cd /usr/lib/ \
RUN wget https://sourceforge.net/projects/pbspro-drmaa/files/latest/download?source=files \
    && cd pbs-drmaa \
    && ./configure && make \
    && touch ~/.pbs_drmaa.conf \
    && echo "
    # This is a copy of my config at Imperial:
    # Also requires 
    # See: http://apps.man.poznan.pl/trac/pbs-drmaa
    
    # pbs_drmaa.conf - Sample pbs_drmaa configuration file:
    
    pool_delay: 60,
    #cache_job_state: 60,
    #wait_thread: 1,
    #pbs_home:'/var/spool/PBS/spool/',
    #job_categories: {
	#default: '-k n', # delete output files from execution hosts
	#longterm: '-p -100 -l nice=5',
	#amd64: '-l arch=amd64',
	#python: '-l software=python',
	#java: '-l software=java,vmem=500mb -v PATH=/opt/sun-jdk-1.6:/usr/bin:/bin',
	#test: '-u test -q testing',
    #}," >> ~/.pbs_drmaa.conf
    && export DRMAA_LIBRARY_PATH=/usr/lib/libdrmaa.so.1.0

# For Alpine:
# https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
#RUN apk update && apk upgrade \
#     && apk add \
#     sudo \
#     gcc


#############################
# Install additional packages
#############################

RUN pip install --upgrade pip
#                          setuptools \
#                          future \
#                          ruffus \
#                          numpy \
#                          pandas \
#                          pyyaml \
#    && pip list

# If running with anaconda:
#RUN conda update conda

# Install base R:
RUN conda install -c r r \
    && conda install rpy2

# Install many essential packages:
#RUN conda install -c r r-essentials \
#    && conda update -c r r-essentials \
#    && conda install rpy2

# conda create -n py35 python=3.5

# rpy2 is not in r-essentials, Dockerfile installation with pip errors, use
# conda install

#########################
# Install package to test 
#########################
# Install CGAT core utilities:

RUN cd home \
    && git clone https://github.com/AntonioJBT/CGATPipeline_core.git \
    && cd CGATPipeline_core \
    && pip install -r requirements.rst \
    && python setup.py install \
    && cd ..

RUN cd home \
    && git clone https://github.com/AntonioJBT/project_quickstart.git \
    && cd project_quickstart \
    && pip install -r requirements.rst \
    && python setup.py install \
    && cd ..

RUN cd home \
    && git clone https://github.com/AntonioJBT/project_quickstart.git \
    && cd project_quickstart \
    && pip install -r requirements.rst \
    && python setup.py install \
    && cd ..

###############################
# Install external dependencies
###############################



############################
# Default action to start in
############################
# Only one CMD is read (if several only the last one is executed)

# Set environment variables
# ENV PATH=/shared/conda-install/envs/cgat-devel/bin:$PATH

# Add an entry point to the cgat command
#ENTRYPOINT ["/shared/conda-install/envs/cgat-devel/bin/cgat"]

#CMD echo "Hello world"
CMD ["/bin/bash"]

# Create a shared folder between docker container and host
#VOLUME ["/shared/data"]

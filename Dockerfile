##################################################
# Dockerfile for pipeline_example 
# https://github.com/AntonioJBT/pipeline_example
##################################################


############
# Base image
############

FROM ubuntu
#FROM continuumio/miniconda3
# It runs on Debian GNU/Linux 8; use e.g. uname -a ; cat /etc/issue.net

# Or simply run:
# docker run --rm -ti continuumio/miniconda3
# docker run --rm -ti ubuntu

#########
# Contact
#########

MAINTAINER Antonio Berlanga-Taylor <a.berlanga@imperial.ac.uk>

#########################
# Update/install packages
#########################

# Install system dependencies
# Ubuntu base image no longer has tzdata, which requires user interaction if
# not installed first manually here:

# If running on Debian and anaconda/miniconda image, use apt-get:
RUN apt-get update && apt-get install -y \
    apt-utils \
    tzdata \
    wget \
    bzip2 \
    fixincludes \
    unzip \
    vim \
    sudo

# Additional packages installed for Ubuntu, taken from CGAT cgat example:
# Probably not needed, didn't test though
RUN sudo apt-get --quiet install -y gcc g++ \
    zlib1g-dev libssl-dev libssl1.0.0 libbz2-dev libfreetype6-dev libpng12-dev \
    libblas-dev libatlas-dev liblapack-dev gfortran libpq-dev r-base-dev \
    libreadline-dev libmysqlclient-dev libboost-dev libsqlite3-dev


########
# PBSPro
########

# Download and install PBSPro:
# See INSTALL in https://github.com/PBSPro/pbspro/blob/master/INSTALL
RUN sudo apt-get --quiet install -y make libtool libhwloc-dev libx11-dev \
      libxt-dev libedit-dev libical-dev ncurses-dev perl \
      postgresql-server-dev-all python-dev tcl-dev tk-dev swig \
      libexpat-dev libssl-dev libxext-dev libxft-dev autoconf \
      automake

RUN sudo apt-get install -y expat libedit2 postgresql python sendmail-bin \
    tcl tk libical1a bison byacc

# PBSPro looks for the header files (tcl and tk *.h files in /usr/include/ ;
# these are in /usr/include/tcl/ so that several versions can be kept.
# Softlink them otherwise PBSPro doesn't compile:
RUN ln -s /usr/include/tcl/*.h /usr/include/

# Also complains about database headers, do the same as above:
RUN ln -sf /usr/include/*sql*/*h /usr/include/

# Also complains about PBS shared database headers and all libraries needed
# which are in /usr/lib/x86_64-linux-gnu/  and not in 
# /usr/lib64/ or /usr/lib/ or /usr/lib/x86_64-linux-gnu/
# Create links for these as above:

#RUN ln -sf /usr/lib/x86_64-linux-gnu/libpq.* /usr/include/ \
#    && ln -sf /usr/lib/x86_64-linux-gnu/libpq.* /usr/lib/ \
#    && ln -sf /usr/lib/x86_64-linux-gnu/libexpat.* /usr/lib/ \
   
# Just link them all... :
RUN ln -sf /usr/lib/x86_64-linux-gnu/lib* /usr/lib/

# PBSPro needs Python version 2.6 or 2.7, this is the default for Ubuntu 16.04

# Get and install PBSPro for Debian systems:
RUN cd /usr/lib/ \
    && wget https://github.com/PBSPro/pbspro/archive/v14.1.0.tar.gz \
    && mv v14.1.0.tar.gz PBSPro_v14.1.0.tar.gz \
    && mv PBSPro_v14.1.0.tar.gz /usr/bin/ \
    && cd /usr/bin/ \
    && tar xvfz PBSPro_v14.1.0.tar.gz \
    && cd pbspro-14.1.0/ \
    && ./autogen.sh \
    && ./configure --help \
    && ./configure --prefix=/opt/pbs \
    && make \
    && sudo make install \
    && sudo /opt/pbs/libexec/pbs_postinstall \
    && touch /etc/pbs.conf
    
# If running on only one system, step 11 in INSTALL:
# https://github.com/PBSPro/pbspro/blob/master/INSTALL
# change pbs.conf as follows:
RUN sed -i 's/PBS_START_MOM=0/PBS_START_MOM=1/g' /etc/pbs.conf

# Continue:
RUN sudo chmod 4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp 

# Continue:
RUN sudo chmod 4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp \
    && sudo /etc/init.d/pbs start \
    && . /etc/profile.d/pbs.sh \
    && qstat -B

CMD ["/bin/bash"]



##################################################
# Dockerfile for pipeline_example 
# https://github.com/AntonioJBT/pipeline_example
##################################################


############
# Base image
############

FROM continuumio/miniconda3
# It runs on Debian GNU/Linux 8; use e.g. uname -a ; cat /etc/issue.net

# Or simply run:
# docker run --rm -ti continuumio/miniconda3

#########
# Contact
#########
MAINTAINER Antonio Berlanga-Taylor <a.berlanga@imperial.ac.uk>

#########################
# Update/install packages
#########################

# Install system dependencies

# If running on Debian and anaconda/miniconda image, use apt-get:
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    fixincludes \
    unzip \
    vim \
    gcc \
    sudo

# # Download and install PBSPro:
# See INSTALL in https://github.com/PBSPro/pbspro/blob/master/INSTALL
RUN sudo apt-get install gcc make libtool libhwloc-dev libx11-dev \
      libxt-dev libedit-dev libical-dev ncurses-dev perl \
      postgresql-server-dev-all python-dev tcl-dev tk-dev swig \
      libexpat-dev libssl-dev libxext-dev libxft-dev autoconf \
      automake

RUN apt-get install expat libedit2 postgresql python sendmail-bin \
    sudo tcl tk libical1a

#wget http://wpc.23a7.iotacdn.net/8023A7/origin2/rl/PBS-Open/CentOS_7.zip
#    && mv CentOS_7.zip PBSPro_CentOS_7.zip \
#    && unzip PBSPro_CentOS_7.zip \
#    && mv CentOS_7 PBSPro_CentOS_7 \
#    && cd PBSPro_CentOS_7 \

RUN wget https://github.com/PBSPro/pbspro/archive/v14.1.0.tar.gz \
    && mv v14.1.0.tar.gz PBSPro_v14.1.0.tar.gz \
    && tar xvfz PBSPro_v14.1.0.tar.gz \
    && cd pbspro-14.1.0/ \
    && ./autogen.sh \
    && ./configure --help \
    && ./configure --prefix=/opt/pbs --with-tcl=/usr/include/tcl8.6/ \
    && make \
    && sudo make install \
    && sudo /opt/pbs/libexec/pbs_postinstall \
    && touch /etc/pbs.conf \
    && sudo chmod 4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp \
    && sudo /etc/init.d/pbs start \
    && . /etc/profile.d/pbs.sh \
    && qstat -B

# Download and install drmaa C library:
RUN cd /usr/lib/ \
RUN wget https://downloads.sourceforge.net/project/pbspro-drmaa/pbs-drmaa/1.0/pbs-drmaa-1.0.19.tar.gz \
    && tar xvfz pbs-drmaa-1.0.19.tar.gz \
    && cd pbs-drmaa-1.0.19 \
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


#############################
# Install additional packages
#############################

RUN pip install --upgrade pip \
    && pip list

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
# conda install rpy2

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

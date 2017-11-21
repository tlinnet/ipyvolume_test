FROM jupyter/scipy-notebook:7fd175ec22c7

# Set variables    
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

# Set root
USER root

# Set user back
USER ${NB_USER}

# The file 'requirements_rtd.txt', on
# https://github.com/maartenbreddels/ipyvolume
# shows that matplotlib should be under version 2?
# https://github.com/matplotlib/matplotlib/releases

ENV ANACONDA_PACKAGES="ipywidgets"
ENV CONDA_PACKAGES="bqplot vaex ipyvolume matplotlib=1.5.3"
ENV PIP_PACKAGES=""

# Install packages
RUN echo "" && \
    conda install -c anaconda $ANACONDA_PACKAGES && \
    conda install -c conda-forge $CONDA_PACKAGES
    #pip install $PIP_PACKAGES

# jupyter notebook password remove
RUN echo "" && \
    mkdir -p $HOME/.jupyter && \
    cd $HOME/.jupyter && \
    echo "c.NotebookApp.token = u''" > jupyter_notebook_config.py

# Make sure the contents of our repo are in ${HOME}
COPY Dockerfile ${HOME}
COPY build_Dockerfile.sh ${HOME}
COPY *.ipynb ${HOME}/

# Sign Notebooks
#WORKDIR /home/jovyan/work
RUN for f in *.ipynb; do jupyter trust $f; done

## Set root, and make folder writable
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
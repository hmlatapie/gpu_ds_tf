# tensorflow (cuda9.0, cudnn7)
#FROM nvidia/cuda:9.0-cudnn7-devel
FROM nvidia/cuda:9.1-cudnn7-devel

MAINTAINER Hugo Latapie <hmlatapie@gmail.com>

SHELL ["/bin/bash", "-c"]

RUN apt update --fix-missing && apt upgrade -y && apt install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

RUN apt install -y aptitude epiphany-browser vim-gnome 

RUN conda update -y conda \ 
   && pip install cython \
   && pip install --upgrade pip \ 
   && conda create -y --name pytorch_TF_p36 python=3.6 \
   && source activate pytorch_TF_p36 \
   && conda install -y pytorch=0.3.1 torchvision cuda91 -c pytorch \
   && pip install visdom dominate \
   && conda install -y jupyter matplotlib \
   && conda install -y scikit-learn 

#for tensorflow... need cuda9.0
#   && pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.8.0-cp36-cp36m-linux_x86_64.whl \
#   && pip install keras

RUN echo `dbus-uuidgen` > /etc/machine-id  

#RUN conda create -y --name keras-gpu --clone pytorch_TF_p36 \
#   && source activate keras-gpu \
#   && conda install -y -c anaconda keras-gpu jupyter matplotlib

#ENTRYPOINT ["/usr/bin/tini", "--"]
#ENTRYPOINT ["/bin/bash", "-c"]

CMD [ "/bin/bash" ]


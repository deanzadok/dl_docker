FROM nvidia/cuda:9.0-cudnn7-devel

RUN rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
	apt-get update
 
# tools:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	cmake \
	wget \
	git \
	nano \
	screen

# curl and sudo need update:
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl \
	sudo

# libraries:
#-------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libboost-all-dev

# python:
# -----------------
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	python-pip \
	python3-pip \
	python-dev \
	python3-dev \
	python-opencv

RUN pip --no-cache-dir install --upgrade pip \
	setuptools

#RUN pip3 --no-cache-dir install --upgrade pip

RUN pip3 --no-cache-dir install --upgrade setuptools

RUN pip --no-cache-dir install --upgrade \
	numpy \
	scipy \
	pandas \
	scikit-learn \
	matplotlib \
	Cython \
	xmltodict \
	easydict \
	tensorboardX \
	Pillow \
	scikit-image \
	https://github.com/Lasagne/Lasagne/archive/master.zip

RUN pip3 --no-cache-dir install --upgrade \
	numpy \
	scipy \
	pandas \
	scikit-learn \
	matplotlib \
	Cython \
	xmltodict \
	easydict \
	tensorboardX \
	Pillow \
	opencv-python \
	scikit-image \
	https://github.com/Lasagne/Lasagne/archive/master.zip

# define sudo user:
#---------------------
#ARG HOME=$HOME
#ARG UID=$UID
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN useradd -m -s /bin/bash dluser && echo "dluser:dlpass" | chpasswd && adduser dluser sudo
#RUN useradd -u 1000 -g 0 -m dluser
#RUN usermod -aG sudo dluser
#RUN echo 'dluser:dlpass' | chpasswd
#COPY entrypoint.sh /entrypoint.sh
WORKDIR /home/dluser
ENV HOME /home/dluser
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]


# Set environment variables:
#-----------------------------
ENV CPATH=$CPLUS_INCLUDE_PATH:/usr/local/cuda/targets/x86_64-linux/include/:/usr/include/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/x86_64-linux-gnu


# more stuff - later move them to appropriate places:
# ---------------------------------------------------
RUN pip --no-cache-dir install --upgrade configobj
RUN pip3 --no-cache-dir install --upgrade configobj

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends firefox

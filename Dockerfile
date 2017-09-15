FROM registry.access.redhat.com/rhel7.4

RUN echo -e '[rhel-7-server-rpms] \nname=rhel-7-server-rpms \nbaseurl=http://repo.home.nicknach.net/repo/rhel-7-server-rpms \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/rhel-7-server-rpms.repo;
RUN echo -e '[cuda] \nname=cuda \nbaseurl=http://repo.home.nicknach.net/repo/cuda \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/cuda.repo;
RUN echo -e '[epel] \nname=epel \nbaseurl=http://repo.home.nicknach.net/repo/epel \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/epel.repo;

RUN yum -y update; yum -y install wget; yum -y install cmake grub2-tools gcc gcc-c++ git make patch pciutils unzip vim-enhanced kernel-headers kernel-devel; yum clean all
RUN yum -y install cuda; yum clean all; export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc; cd /tmp && wget -q "http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz"; tar -C /usr/local -xf /tmp/cudnn-8.0-linux-x64-v6.0.tgz; /bin/rm /tmp/cudnn-8.0-linux-x64-v6.0.tgz
RUN yum -y install python34-pip; yum -y install python34-devel; yum clean all; pip3 install --upgrade pip

RUN pip3 install tensorflow-gpu==1.3.0rc0
RUN pip3 install keras
RUN pip3 install jupyter
RUN pip3 install matplotlib
RUN pip3 install numpy

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks
COPY data /data
COPY figures /figures


# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

EXPOSE 8888 6006

WORKDIR "/notebooks"

CMD /run_jupyter.sh --allow-root

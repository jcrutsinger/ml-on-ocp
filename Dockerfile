
# mlcc -i RHEL7.4,CUDA,Python2,Keras,TensorFlow

FROM registry.access.redhat.com/rhel7.4

RUN echo -e '[rhel7.4] \nname=rhel7.4 \nbaseurl=http://download.devel.redhat.com/released/RHEL-7/7.4/Server/x86_64/os/ \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/rhel7.4.repo; yum -y install wget; yum clean all

RUN wget -nd -np -A.repo -rP /etc/yum.repos.d/ "http://perf1.perf.lab.eng.bos.redhat.com/pub/bgray/mlcc_repos/rhel7.4/"; yum -y update; yum -y install cmake gcc gcc-c++ git make patch pciutils unzip vim-enhanced; yum clean all

RUN yum -y install cuda; yum clean all; export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc; cd /tmp && wget -q "http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz"; tar -C /usr/local -xf /tmp/cudnn-8.0-linux-x64-v6.0.tgz; /bin/rm /tmp/cudnn-8.0-linux-x64-v6.0.tgz

RUN yum -y install python2-pip || yum -y install python-pip; yum -y install python2-devel || yum -y install python-devel; yum clean all; pip install --upgrade pip

RUN pip install tensorflow-gpu==1.3.0rc0

RUN pip install keras

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]

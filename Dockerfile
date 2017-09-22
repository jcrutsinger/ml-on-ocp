FROM registry.access.redhat.com/rhel7.4

RUN echo -e '[rhel7] \nname=rhel7 \nbaseurl=http://repo.home.nicknach.net/repo/rhel-7-server-rpms \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/rhel7.repo;
RUN echo -e '[cuda] \nname=cuda \nbaseurl=http://repo.home.nicknach.net/repo/cuda \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/cuda.repo;
RUN echo -e '[epel] \nname=epel \nbaseurl=http://repo.home.nicknach.net/repo/epel \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/epel.repo;

RUN yum -y update && yum clean all
RUN yum -y install wget cmake gcc gcc-c++ git make patch pciutils unzip vim-enhanced && yum clean all
RUN yum -y install cuda && yum clean all
RUN export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; 
RUN echo -e 'export CUDA_VISIBLE_DEVICES=0\nexport CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc; cd /tmp && wget -q "http://repo.home.nicknach.net/repo/nvidia/cudnn-8.0-linux-x64-v6.0.tgz"; tar -C /usr/local -xf /tmp/cudnn-8.0-linux-x64-v6.0.tgz; /bin/rm /tmp/cudnn-8.0-linux-x64-v6.0.tgz
RUN ldconfig;

##python3
#RUN yum -y install python34-pip
#RUN pip3 install --upgrade pip
#RUN yum -y install python34-devel && yum clean all; 
#RUN pip3 install tensorflow-gpu==1.3.0
#RUN pip3 install keras
#RUN pip3 install jupyter
#RUN pip3 install matplotlib

#python2
RUN yum -y install python-pip;
RUN pip install --upgrade pip;
RUN yum -y install python-devel && yum clean all;
RUN pip install tensorflow-gpu==1.3.0
RUN pip install jupyter
RUN pip install matplotlib
RUN pip install keras

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

COPY run_jupyter.sh /
COPY notebooks /notebooks

WORKDIR "/notebooks"

EXPOSE 8888 6006


CMD /run_jupyter.sh --allow-root

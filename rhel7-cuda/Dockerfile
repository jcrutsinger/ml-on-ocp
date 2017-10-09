FROM registry.access.redhat.com/rhel7.4

ENV REPO_URL=http://repo.home.nicknach.net/repo \
	REPO_RHEL=rhel-7-server-rpms \
	REPO_EPEL=epel \
	REPO_CUDA=cuda \
	REPO_NV=nvidia \
	DNN_VER=cudnn-8.0-linux-x64-v6.0.tgz 
	
RUN echo -e "[rhel7] \nname=rhel7 \nbaseurl=$REPO_URL/$REPO_RHEL \nenabled=1 \ngpgcheck=0 \n" >> /etc/yum.repos.d/rhel7.repo;
RUN echo -e "[cuda] \nname=cuda \nbaseurl=$REPO_URL/$REPO_CUDA \nenabled=1 \ngpgcheck=0 \n" >> /etc/yum.repos.d/cuda.repo;
RUN echo -e "[epel] \nname=epel \nbaseurl=$REPO_URL/$REPO_EPEL \nenabled=1 \ngpgcheck=0 \n" >> /etc/yum.repos.d/epel.repo;

RUN yum -y update && yum clean all && rm -rf /var/cache/yum/*
RUN yum -y install wget cmake gcc gcc-c++ git make patch pciutils unzip vim-enhanced && yum clean all && rm -rf /var/cache/yum/*
RUN yum -y install cuda-8-0.x86_64 && yum clean all && rm -rf /var/cache/yum/*
RUN export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; 
RUN echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc;
RUN cd /tmp && wget -q "$REPO_URL/$REPO_NV/$DNN_VER"; tar -C /usr/local -xf /tmp/$DNN_VER; /bin/rm /tmp/$DNN_VER
RUN ldconfig

CMD echo "Done!"
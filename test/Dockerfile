FROM registry.access.redhat.com/rhel7.4

RUN echo -e '[rhel-7-server-rpms] \nname=rhel-7-server-rpms \nbaseurl=http://repo.home.nicknach.net/repo/rhel-7-server-rpms \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/rhel-7-server-rpms.repo;
RUN echo -e '[epel] \nname=epel \nbaseurl=http://repo.home.nicknach.net/repo/epel \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/epel.repo;
RUN echo -e '[cuda] \nname=cuda \nbaseurl=http://repo.home.nicknach.net/repo/cuda \nenabled=1 \ngpgcheck=0 \n' >> /etc/yum.repos.d/cuda.repo;

RUN yum install -y cmake curl gcc gcc-c++ git make patch pciutils unzip wget python-pip kernel-headers kernel-devel dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
RUN yum -y install cuda; yum clean all; export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc; cd /tmp && wget -q "http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz"; tar -C /usr/local -xf /tmp/cudnn-8.0-linux-x64-v6.0.tgz; /bin/rm /tmp/cudnn-8.0-linux-x64-v6.0.tgz
RUN yum -y install python-devel; pip install --upgrade pip
RUN pip install "https://github.com/Lasagne/Lasagne/archive/master.zip"
RUN yum install -y cmake3; cd /tmp && git clone "https://github.com/Theano/libgpuarray.git"; mkdir -p /tmp/libgpuarray/Build && cd /tmp/libgpuarray/Build && cmake3 .. -DCMAKE_BUILD_TYPE=Release && make && make install; pip install Cython; cd /tmp/libgpuarray && python setup.py build_ext -L /usr/local/lib64 -I /usr/local/include && python setup.py install && ldconfig; echo -e '[global] \ndevice = cuda0 \nfloatX = float32 \n[nvcc] \nfastmath=True \n[cuda] \nroot=/usr/local/cuda \n' >> ~/.theanorc ; pip install Theano

COPY mnist.py /

CMD python mnist.py

FROM registry.access.redhat.com/rhel7.4

RUN yum install -y cmake curl gcc gcc-c++ git make patch pciutils unzip

RUN yum install -y cuda; export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' &gt;&gt; ~/.bashrc; cd /tmp &amp;&amp; curl -fsSLO "http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz"; tar -C /usr/local -zxf /tmp/cudnn-8.0-linux-x64-v6.0.tgz
RUN yum install -y python2*pip python-devel; pip install --upgrade pip
RUN pip install "https://github.com/Lasagne/Lasagne/archive/master.zip"
RUN yum install -y cmake3; cd /tmp &amp;&amp; git clone "https://github.com/Theano/libgpuarray.git"; mkdir -p /tmp/libgpuarray/Build &amp;&amp; cd /tmp/libgpuarray/Build &amp;&amp; cmake3 .. -DCMAKE_BUILD_TYPE=Release &amp;&amp; make &amp;&amp; make install; pip install Cython; cd /tmp/libgpuarray &amp;&amp; python setup.py build_ext -L /usr/local/lib64 -I /usr/local/include &amp;&amp; python setup.py install &amp;&amp; ldconfig; echo -e '[global] \ndevice = cuda0 \nfloatX = float32 \n[nvcc] \nfastmath=True \n[cuda] \nroot=/usr/local/cuda \n' &gt;&gt; ~/.theanorc ; pip install Theano
RUN curl https://raw.githubusercontent.com/Lasagne/Lasagne/master/examples/mnist.py -o /root/mnist.py

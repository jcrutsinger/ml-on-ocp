FROM rhel7-cuda

RUN export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; 

##python3
#RUN yum -y install python34-pip python34-devel && yum clean all
#RUN pip3 install --upgrade pip
#RUN pip3 install tensorflow-gpu==1.3.0
#RUN pip3 install keras
#RUN pip3 install jupyter
#RUN pip3 install matplotlib

#python2
RUN yum -y install python-pip python-devel && yum clean all
RUN pip install --upgrade pip
RUN pip install tensorflow-gpu==1.3.0
RUN pip install jupyter
RUN pip install matplotlib
RUN pip install keras

#setup dir
RUN mkdir /opt/ml-on-ocp
COPY *.ipynb /opt/ml-on-ocp/
COPY data /opt/ml-on-ocp/data
COPY figures /opt/ml-on-ocp/figures

WORKDIR "/opt/ml-on-ocp"

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

EXPOSE 8888 6006

CMD /run_jupyter.sh --allow-root

FROM rhel7-cuda:latest

RUN yum -y install python-pip python-devel && yum clean all && rm -rf /var/cache/yum/*
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tensorflow-gpu==1.3.0
RUN pip install --no-cache-dir jupyter
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir keras

#setup dir
RUN mkdir -p /opt/ml-on-ocp/data/nmo && mkdir /opt/ml-on-ocp/data/mnist

COPY *.ipynb /opt/ml-on-ocp/
COPY data /opt/ml-on-ocp/data
COPY figures /opt/ml-on-ocp/figures

WORKDIR "/opt/ml-on-ocp"

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

EXPOSE 8888 6006

CMD /run_jupyter.sh --allow-root

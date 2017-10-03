# This repo's content is for building and deploying CUDA/GPU-enabled ML/AI images on Openshift 3.6.
## You must first build the base image (adds cuda layer)
## You can create your own Dockerfile for whatever your ML platform is.  This one is for Tensorflow+Jupyter

<code>
# Env vars
NODE_NAME=hv4.home.nicknach.net
GPU_NAME=GTX_970
PROJECT=ml-on-ocp
GIT=https://github.com/nnachefski/ml-on-ocp.git
APP=jupyter
</code>

1.  Join a bare-metal Openshift 3.6 node to your cluster w/ a CUDA-enabled NVIDIA GPU (label that node appropriately)

oc label node $NODE_NAME alpha.kubernetes.io/nvidia-gpu-name='$GPU_NAME' --overwrite

2.  create the project
oc new-project ml-on-ocp

3.  set anyuid for the default serviceaccount
oc adm policy add-scc-to-user anyuid -z default

4.  set an alias to refresh from github
alias refdemo='cd ~; rm -rf $PROJECT; git clone $GIT; cd $PROJECT'

5.  now do the refresh
refdemo

6.  now build the base image
oc new-build . --name=rhel7-cuda --context-dir=rhel7-cuda

7.  now build/deploy the AI/ML framework
oc new-app . --name=jupyter

8.  expose the jupyter UI port
oc expose svc jupyter --port 8888

9.  test the mnist notebook, it will run on the general CPU (use top), then patch the dc to set resource limits and nodeaffinity 
oc patch dc $APP -p '{"spec":{"template":{"spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"alpha.kubernetes.io/nvidia-gpu-name","operator":"In","values":["GTX_970"]}]}]}}},"containers":[{"name":"$APP","resources":{"limits":{"alpha.kubernetes.io/nvidia-gpu":"1"}}}]}}}}'

## now run the mnist notebook again and see that it scheduled on the GPU (use nvidia-smi on the bare-metal node)


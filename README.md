## This repo's content is for building and deploying CUDA/GPU-enabled ML/AI images on Openshift 3.6.
### You must first build the base image (which adds the cuda layer)
#### This example uses Tensorflow+Jupyter

1.  join a bare-metal node to your 3.6 cluster (w/ an NVIDIA GPU) and label that node appropriately:
	> oc label node hv4.home.nicknach.net alpha.kubernetes.io/nvidia-gpu-name='GTX_970' --overwrite
	(dont forget to enable the features gate for accelerators in the node-config.yml for this node)

2.  create the project:
	> oc new-project ml-on-ocp

3.  set anyuid for the default serviceaccount:
	> oc adm policy add-scc-to-user anyuid -z default

4.  now build the base image
	> oc new-build https://github.com/nnachefski/ml-on-ocp.git --name=rhel7-cuda --context-dir=rhel7-cuda

5.  now build/deploy the AI/ML framework
	> oc new-app https://github.com/nnachefski/ml-on-ocp.git --name=jupyter

6.  expose the jupyter UI port
	> oc expose svc jupyter --port 8888

7.  then patch the dc to set resource limits and nodeaffinity 
	> oc patch dc jupyter -p '{"spec":{"template":{"spec":{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"alpha.kubernetes.io/nvidia-gpu-name","operator":"In","values":["GTX_970"]}]}]}}},"containers":[{"name":"jupyter","resources":{"limits":{"alpha.kubernetes.io/nvidia-gpu":"1"}}}]}}}}'

#### now run the mnist notebook again and see that it scheduled on the GPU (use nvidia-smi on the bare-metal node)


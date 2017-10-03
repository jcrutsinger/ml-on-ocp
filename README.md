# create the project and set anyuid for the default serviceaccount
oc new-project ml-on-ocp
oc adm policy add-scc-to-user anyuid -z default

# set an alias to refresh from github
alias refdemo='cd ~; rm -rf ml-on-ocp; git clone https://github.com/nnachefski/ml-on-ocp.git; cd ml-on-ocp'

# now do the refresh
refdemo

# now build the base image
oc new-build . --name=rhel7-cuda --context-dir=rhel7-cuda

# now build/deploy the AI/ML framework
oc new-build . --name=jupyter

# Scheduler Operator
oc get clusteroperator/kube-scheduler
oc get scheduler cluster -o yaml
oc get events -n  openshift-cluster-kube-scheduler-operator
oc get pod -n openshift-kube-scheduler-operator
oc get pod -n openshift-kube-scheduler
oc project openshift-kube-scheduler
oc get pod
oc logs openshift-kube-scheduler-ip-10-0-136-87.eu-west-1.compute.internal

# NodeSelector
oc label node ip-10-0-151-36.eu-west-1.compute.internal gpu=yes
oc label node ip-10-0-151-36.eu-west-1.compute.internal gpu-

oc get nodes -Lgpu
oc new-project node-selector
oc apply -f pod-node-selector.yaml -n node-selector
oc describe pod nginx-node-selector
oc get pod -o wide

oc project openshift-kube-scheduler
oc logs openshift-kube-scheduler-ip-10-0-181-10.eu-west-1.compute.internal | grep nginx-node-selector

oc apply -f pod-node-selector-fail.yaml
oc get pod -o wide
oc describe pod nginx-node-selector

# NodeSelector / MachineSet
oc get machineset -A
oc create -f machinset_spot.yaml -n openshift-machine-api
oc get machineset -A
oc get machine -A
oc patch MachineSet cluster-1b74-r45lt-worker-eu-west-1a-spot --type='json' -p='[{"op":"add","path":"/spec/template/spec/metadata/labels", "value":{"aws_spot":"True"}}]'  -n openshift-machine-api
sc scale machineset cluster-1b74-r45lt-worker-eu-west-1a-spot --replicas=0 -n openshift-machine-api
oc scale machineset cluster-1b74-r45lt-worker-eu-west-1a-spot --replicas=2 -n openshift-machine-api
oc get machine -A
oc get nodes -Laws_spot -laws_spot
oc adm new-project node-selector --node-selector="aws_spot=True"
oc project node-selector
oc new-app ruby~https://github.com/sclorg/ruby-ex.git
oc get nodes -laws_spot -Laws_spot
oc get pod -o wide

# ClusterAutoScaler
oc create -f machine_autoscaler.yaml -n openshift-machine-api
oc create -f clusterautoscaler.yml -n openshift-machine-api
oc get cdr | grep machine.openshift.io
oc get machine -n openshift-machine-api
oc get machineset  -n openshift-machine-api
oc new-project autoscale-example
oc adm new-project autoscale-example --node-selector="aws_spot=True"
oc project autoscale-example
oc create -n autoscale-example -f https://raw.githubusercontent.com/openshift/training/master/assets/job-work-queue.yaml

# Node Affinity
oc new-project node-affinity
oc get nodes -L gpu -L mining
oc label node ip-10-0-151-36.eu-west-1.compute.internal mining=yes
oc label node ip-10-0-173-245.eu-west-1.compute.internal gpu=yes
oc apply -f pod-node-affinity.yaml
oc get pod -o wide
oc delete pod nginx-node-affinity
oc label node ip-10-0-151-36.eu-west-1.compute.internal generic-
oc label node ip-10-0-173-245.eu-west-1.compute.internal gpu-

oc label node ip-10-0-151-36.eu-west-1.compute.internal mining=yes
oc label node ip-10-0-173-245.eu-west-1.compute.internal gpu=yes
oc apply -f pod-node-affinity-preferred.yaml
oc get pod -o wide

# Pod Affinity
oc get nodes -L gpu -L mining
oc apply -f pod-pod-affinity.yaml
oc apply -f pod-pod-antiaffinity.yaml
oc apply -f pod-pod-affinity-fail.yaml

# Taints
oc adm taint nodes ip-10-0-135-243.eu-west-1.compute.internal gpu=yes:NoSchedule
oc apply -f pod-node-selector-tolerations.yaml

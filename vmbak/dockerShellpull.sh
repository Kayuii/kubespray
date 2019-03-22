#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# kuberspay v2.6.0版本
registry_proxy_image_tag=0.4

kube_version=v1.13.0
kubeadm_version=${kube_version}
etcd_version=v3.2.24
calico_version="v3.1.3"
calico_ctl_version="v3.1.3"
calico_cni_version="v3.1.3"
calico_policy_version="v3.1.3"
calico_rr_version="v0.6.1"
flannel_version="v0.10.0"
flannel_cni_version="v0.3.0"
cni_version="v0.6.0"
weave_version=2.5.0
pod_infra_version=3.1
contiv_version=1.2.1
cilium_version="v1.3.0"
kube_router_version="v0.2.1"
multus_version="v3.1.autoconf"
netcheck_version="v1.0"
dnsmasq_version=2.78
kubedns_version=1.14.13
coredns_version="1.2.6"
nodelocaldns_version="1.15.0"
dnsmasqautoscaler_version=1.1.2
dnsautoscaler_version=1.3.0
helm_version="v2.11.0"
metrics_server_version="v0.3.1"
cert_manager_version="v0.5.2"
addon_resizer_version="1.8.3"
latest="latest"
nginx_version="1.13"

K8S_URL=k8s.gcr.io
GCR_URL=gcr.io/google_containers
GCRX_URL=gcr.io
QUAY_URL=quay.io
LOCAL_URL=192.168.1.29

images_QUAY=(
coreos/etcd:${etcd_version}
coreos/flannel:${flannel_version}
coreos/flannel-cni:${flannel_cni_version}
calico/ctl:${calico_ctl_version}
calico/node:${calico_version}
calico/cni:${calico_cni_version}
calico/kube-controllers:${calico_policy_version}
calico/routereflector:${calico_rr_version}
l23network/k8s-netchecker-agent:${netcheck_version}
l23network/k8s-netchecker-server:${netcheck_version}
external_storage/local-volume-provisioner:v2.1.0
external_storage/cephfs-provisioner:v2.1.0-k8s1.11
kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
jetstack/cert-manager-controller:${cert_manager_version}
)

images_GCR=(
pause-amd64:${pod_infra_version}
k8s-dns-kube-dns-amd64:${kubedns_version}
k8s-dns-dnsmasq-nanny-amd64:${nodelocaldns_version}
k8s-dns-sidecar-amd64:${kubedns_version}
cluster-proportional-autoscaler-amd64:${dnsmasqautoscaler_version}
cluster-proportional-autoscaler-amd64:${dnsautoscaler_version}
kubernetes-dashboard-amd64:v1.10.0
kube-registry-proxy:${registry_proxy_image_tag}
)

images_K8S=(
k8s-dns-node-cache:${nodelocaldns_version}
metrics-server-amd64:${metrics_server_version}
addon-resizer:${addon_resizer_version}
)

images_GCRX="kubernetes-helm/tiller:"${helm_version}

imgaes_other=(
xueshanf/install-socat:${latest}
docker.io/weaveworks/weave-kube:${weave_version}
docker.io/weaveworks/weave-npc:${weave_version}
contiv/netplugin:${contiv_version}
contiv/netplugin-init:${latest}
contiv/auth_proxy:${contiv_version}
ferest/etcd-initer:${latest}
contiv/ovs:${latest}
docker.io/cilium/cilium:${cilium_version}
cloudnativelabs/kube-router:${kube_router_version}
docker.io/nfvpe/multus:${multus_version}
nginx:${nginx_version}
andyshinn/dnsmasq:${dnsmasq_version}
coredns/coredns:${coredns_version}
lachlanevenson/k8s-helm:${helm_version}
)

for imageName in ${images_QUAY[@]} ; do
  #echo ${QUAY_URL}$imageName
  docker pull $LOCAL_URL/quay_io/$imageName
  docker tag $LOCAL_URL/quay_io/$imageName $QUAY_URL/$imageName
  docker rmi $LOCAL_URL/quay_io/$imageName
done

for imageName in ${images_GCR[@]} ; do
  #echo ${GCR_URL}$imageName
  docker pull $LOCAL_URL/gcr_io/$imageName
  docker tag $LOCAL_URL/gcr_io/$imageName $GCR_URL/$imageName
  docker rmi $LOCAL_URL/gcr_io/$imageName
done

for imageName in ${images_K8S[@]} ; do
  #echo ${K8S_URL}$imageName
  docker pull $LOCAL_URL/k8s_gcr_io/$imageName
  docker tag $LOCAL_URL/k8s_gcr_io/$imageName $K8S_URL/$imageName
  docker rmi $LOCAL_URL/k8s_gcr_io/$imageName
done

for imageName in ${imgaes_other[@]} ; do
  #echo $imageName
  docker pull $LOCAL_URL/k8s_io/$imageName
  docker tag $LOCAL_URL/k8s_io/$imageName $imageName
  docker rmi $LOCAL_URL/k8s_io/$imageName
done

docker pull $LOCAL_URL/gcrx_io/$imageName
docker tag $LOCAL_URL/gcrx_io/$imageName $GCRX_URL/$imageName
docker rmi $LOCAL_URL/gcrx_io/$imageName

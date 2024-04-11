import '.justfiles/ansible.just'
import '.justfiles/prerequisites.just'
import '.justfiles/flux.just'

cluster_name := 'home'
cluster_address := '10.0.8.10'
kubeconfig_file := '/tmp/k3s.yaml'

default: install apply kubeconfig flux-bootstrap

kubeconfig:
    kubectl config set clusters.{{ cluster_name }}.server https://{{ cluster_address }}:6443
    kubectl config set clusters.{{ cluster_name }}.certificate-authority-data $(cat {{ kubeconfig_file }} | yq ".clusters.[].cluster.certificate-authority-data")
    kubectl config set contexts.{{ cluster_name }}.cluster {{ cluster_name }}
    kubectl config set users.{{ cluster_name }}.client-certificate-data $(cat {{ kubeconfig_file }} | yq ".users.[].user.client-certificate-data")
    kubectl config set users.{{ cluster_name }}.client-key-data $(cat {{ kubeconfig_file }} | yq ".users.[].user.client-key-data")



[![k3s](https://img.shields.io/badge/k3s-v1.25-blue?style=flat&logo=k3s)](https://k3s.io/)


## My home Kubernetes cluster :sailboat:
_... heavily inspired by the works of [onedr0p](https://github.com/luander/k3s-cluster/)_ :rocket:


> Work in progress :construction_worker:

<br/>

## :book:&nbsp; Overview

This repository _is_ my homelab Kubernetes cluster in a declarative state. [Flux2](https://github.com/fluxcd/flux2) watches my [cluster](./cluster/) folder and makes the changes to my cluster based on the YAML manifests.

---

## :computer:&nbsp; Cluster setup

My cluster is [k3s](https://k3s.io/) and multi-architecture being composed by:
- 3 [Raspberry PI 4 model b 4Gb](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) 
- 2 Intel NUC [Skull Canyon](https://www.intel.com/content/www/us/en/products/docs/boards-kits/nuc/nuc-kit-nuc6i7kyk-features-configurations-video.html).

---


## :handshake:&nbsp; Thanks

A lot of inspiration for my cluster came from the people that have shared their clusters over at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes)

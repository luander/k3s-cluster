<img src="https://k3s.io/images/logo-k3s.svg" width="144px" height="144px"/>
<br />

## My home Kubernetes cluster :sailboat:
_... heavily inspired by the works of [onedr0p](https://onedr0p.github.io/home-cluster/)_ :rocket:

<br />

> Work in progress :construction_worker:

<br/>

[![k3s](https://img.shields.io/badge/k3s-v1.23-blue?style=for-the-badge)](https://k3s.io/)
[![KICS Scan](https://github.com/luander/k3s-cluster/actions/workflows/kics.yaml/badge.svg)](https://github.com/luander/k3s-cluster/actions/workflows/kics.yaml)
[![Schedule - Update Flux](https://github.com/luander/k3s-cluster/actions/workflows/flux-schedule.yaml/badge.svg)](https://github.com/luander/k3s-cluster/actions/workflows/flux-schedule.yaml)

<br/>

## :book:&nbsp; Overview

This repository _is_ my homelab Kubernetes cluster in a declarative state. [Flux2](https://github.com/fluxcd/flux2) watches my [cluster](./cluster/) folder and makes the changes to my cluster based on the YAML manifests.

---

## :computer:&nbsp; Cluster setup

My cluster is [k3s](https://k3s.io/) and multi-architecture being composed by 3 [Raspberry PI 4 model b 4Gb](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) and one Intel NUC [Skull Canyon](https://www.intel.com/content/www/us/en/products/docs/boards-kits/nuc/nuc-kit-nuc6i7kyk-features-configurations-video.html). 

Key cluster components:

  - [longhorn](https://longhorn.io/): Cluster storage, since version 1.1.0 it supports ARM64 processors and also has several improvements such as built-in support for ReadWriteMany, prometheus support and more.
  
  TODO: more to come

---


## :handshake:&nbsp; Thanks

A lot of inspiration for my cluster came from the people that have shared their clusters over at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes)

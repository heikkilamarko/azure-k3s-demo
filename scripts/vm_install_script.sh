#!/bin/bash
set -euo pipefail

echo "127.0.0.1 registry.test" >> /etc/hosts

cat <<EOF > /etc/ssh/sshd_config.d/99-disable-root.conf
PermitRootLogin no
EOF
chmod 644 /etc/ssh/sshd_config.d/99-disable-root.conf

systemctl restart ssh

cat <<EOF > /etc/sysctl.d/90-kubelet.conf
vm.panic_on_oom=0
vm.overcommit_memory=1
kernel.panic=10
kernel.panic_on_oops=1
EOF

sysctl -p /etc/sysctl.d/90-kubelet.conf

mkdir -p /etc/rancher/k3s/config.yaml.d
cat <<EOF > /etc/rancher/k3s/config.yaml.d/config.yaml
protect-kernel-defaults: true
secrets-encryption: true
write-kubeconfig-mode: "644"
kube-apiserver-arg:
  - "enable-admission-plugins=NodeRestriction,EventRateLimit"
  - "admission-control-config-file=/var/lib/rancher/k3s/server/psa.yaml"
  - "audit-log-path=/var/lib/rancher/k3s/server/logs/audit.log"
  - "audit-policy-file=/var/lib/rancher/k3s/server/audit.yaml"
  - "audit-log-maxage=30"
  - "audit-log-maxbackup=10"
  - "audit-log-maxsize=100"
kube-controller-manager-arg:
  - "terminated-pod-gc-threshold=10"
kubelet-arg:
  - "streaming-connection-idle-timeout=5m"
  - "tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
EOF

cat <<EOF > /etc/rancher/k3s/registries.yaml
configs:
  registry.test:
    auth:
      username: "$ACR_USERNAME"
      password: "$ACR_PASSWORD"
    tls:
      insecure_skip_verify: true
  $ACR_LOGIN_SERVER:
    auth:
      username: "$ACR_USERNAME"
      password: "$ACR_PASSWORD"
EOF

mkdir -p /var/lib/rancher/k3s/server/manifests
mkdir -p -m 700 /var/lib/rancher/k3s/server/logs

cat <<EOF > /var/lib/rancher/k3s/server/audit.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
EOF

cat <<EOF > /var/lib/rancher/k3s/server/psa.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: PodSecurity
  configuration:
    apiVersion: pod-security.admission.config.k8s.io/v1beta1
    kind: PodSecurityConfiguration
    defaults:
      enforce: "restricted"
      enforce-version: "latest"
      audit: "restricted"
      audit-version: "latest"
      warn: "restricted"
      warn-version: "latest"
    exemptions:
      usernames: []
      runtimeClasses: []
      namespaces:
        - kube-system
        - cert-manager
        - opentelemetry-collector
        - examples
- name: EventRateLimit
  configuration:
    apiVersion: eventratelimit.admission.k8s.io/v1alpha1
    kind: Configuration
    limits:
      - type: Namespace
        qps: 50
        burst: 100
      - type: User
        qps: 10
        burst: 50
EOF

cat <<EOF > /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    globalArguments: []
    providers:
      kubernetesIngress:
        allowExternalNameServices: true
    ports:
      web:
        redirections:
          entryPoint:
            to: websecure
            scheme: https
EOF

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -

chmod -R 600 /var/lib/rancher/k3s/server/tls/*.crt

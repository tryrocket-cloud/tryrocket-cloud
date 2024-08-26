# vaultwarden

## Install

Install vaultwarden as an Argo CD application

    create database user 
    create a new database with this new user and matching the creds in deployment

    argocd app create vaultwarden \
                        --repo https://github.com/tryrocket-cloud/tryrocket-cloud.git \
                        --path applications/vaultwarden/overlays/production \
                        --dest-server https://192.168.178.101:6443 \
                        --dest-namespace vaultwarden \
                        --revision main \
                        --project default \
                        --sync-policy automated \
                        --self-heal \
                        --auto-prune

## TODOs

remove unneeded permissions from backup-role.yaml




          containers:
          # TODO: custom docker image
          - name: ansible-runner
            image: quay.io/ansible/ansible-runner:latest
            args: 
              - /bin/sh
              - -c
              - |
                curl -sSL -o argocd-linux-amd64 "https://github.com/argoproj/argo-cd/releases/download/v2.12.0/argocd-linux-amd64"
                chmod +x argocd-linux-amd64
                mv argocd-linux-amd64 /usr/local/bin/argocd
                #argocd version
                pip3 install kubernetes &&
                ansible-galaxy collection install kubernetes.core &&
                ansible-playbook /playbooks/my-playbook.yml
            volumeMounts:
            - name: playbook-volume
              mountPath: /playbooks
            - name: kubeconfig
              mountPath: /etc/kubeconfig
          restartPolicy: Never
          volumes:
          - name: playbook-volume
            configMap:
              name: ansible-playbook-configmap
          - name: kubeconfig
            configMap:
              name: kubeconfig-backup-sa

      backoffLimit: 0  # Optional: This will stop retrying the job if it fails

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ansible-playbook-configmap
data:
  my-playbook.yml: |
    ---
    - name: Backup Vaultwarden
      hosts: localhost
      gather_facts: false
      collections:
        - kubernetes.core

      tasks:
        - name: Ensure the message is echoed
          command: echo "Hello, World!"

        - name: Disable ArgoCD auto-sync
          command: argocd app set vaultwarden --sync-policy none --server argocd.tryrocket.cloud --insecure --auth-token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJhZG1pbjphcGlLZXkiLCJleHAiOjE3MjQzMzU2NzYsIm5iZiI6MTcyMzQ3MTY3NiwiaWF0IjoxNzIzNDcxNjc2LCJqdGkiOiJ0ZXN0In0.aNNlFEcvL84fPUv-wvkw6DCet1BmlYTormJqKVlCfTM

        - name: Scale down the deployment to zero replicas
          k8s:
            kubeconfig: /etc/kubeconfig/kubeconfig.yaml
            api_version: apps/v1
            kind: Deployment
            name: vaultwarden
            namespace: vaultwarden
            state: present
            definition:
              spec:
                replicas: 0

        - name: Wait for the deployment to scale down
          k8s_info:
            kubeconfig: /etc/kubeconfig/kubeconfig.yaml
            api_version: apps/v1
            kind: Deployment
            name: vaultwarden
            namespace: vaultwarden
          register: deployment_info
          until: deployment_info.resources[0].status.replicas | default(0) == 0
          retries: 10
          delay: 5

        - name: Wait for all pods to terminate
          k8s_info:
            kubeconfig: /etc/kubeconfig/kubeconfig.yaml
            api_version: v1
            kind: Pod
            namespace: vaultwarden
            label_selectors:
              - app=vaultwarden
          register: pod_info
          until: pod_info.resources | length == 0
          retries: 10
          delay: 5

        - name: Confirm that the deployment has no running replicas
          debug:
            msg: "Deployment has been scaled down to zero replicas and all pods have terminated."

        - name: Delete existing job if it exists
          k8s:
            kubeconfig: /etc/kubeconfig/kubeconfig.yaml
            api_version: batch/v1
            kind: Job
            name: vaultwarden-backup
            namespace: vaultwarden
            state: absent
          ignore_errors: true  # Ignore errors if the job doesn't exist

        - name: Create a new job with the attached volume
          k8s:
            kubeconfig: /etc/kubeconfig/kubeconfig.yaml
            api_version: batch/v1
            kind: Job
            namespace: vaultwarden
            definition:
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: vaultwarden-backup
              spec:
                template:
                  spec:
                    containers:
                    - name: busybox
                      image: busybox
                      args: 
                        - /bin/sh
                        - -c
                        - |
                          ls -la /data
                      volumeMounts:
                      - name: vaultwarden-storage
                        mountPath: /data
                    restartPolicy: OnFailure
                    volumes:
                      - name: vaultwarden-storage
                        persistentVolumeClaim:
                          claimName: vaultwarden-pvc

        - name: Enable ArgoCD auto-sync
          command: argocd app set vaultwarden --sync-policy automated --self-heal --auto-prune --server argocd.tryrocket.cloud --insecure --auth-token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJhZG1pbjphcGlLZXkiLCJleHAiOjE3MjQzMzU2NzYsIm5iZiI6MTcyMzQ3MTY3NiwiaWF0IjoxNzIzNDcxNjc2LCJqdGkiOiJ0ZXN0In0.aNNlFEcvL84fPUv-wvkw6DCet1BmlYTormJqKVlCfTM
## Backup

- `--host tryrocket.cloud --tags daily --tags vaultwarden:$VAULTWARDEN_VERSION`
- `--tags manual --tags vaultwarden:$VAULTWARDEN_VERSION`
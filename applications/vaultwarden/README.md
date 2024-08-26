# vaultwarden

## Install

### ArgoCD

Install vaultwarden as an Argo CD application

    # prepare database
    create database user
    create a new database with this new user and matching the creds in deployment

    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/production/application.yaml -n argocd
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/staging/application.yaml -n argocd
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/testing/application.yaml -n argocd
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/backup-recover/application.yaml -n argocd

## Update

To change the production version of `vaultwarden` navigate to [kustomization.yaml](./overlays/production/kustomization.yaml).

## Backup

### Restic

This project implements two types of backup strategies using Restic to ensure data safety and reliability. Below, you'll find details about both the automated backup running in a `tryrocket.cloud` k3s cluster and the manual, on-demand backup that can be triggered locally.

### 1. Automated Backup (`tryrocket.cloud`)

The automated backup process is configured to run regularly in a k3s cluster. This process ensures that critical data is backed up at `0 3 * * *` (*at 03:00 o'clock*) without requiring any manual intervention.

#### Configuration:

- [CronJob](./base-backup/backup-cronjob-v3.yaml)
- Restic: `--host tryrocket.cloud --tags daily --tags vaultwarden:$VAULTWARDEN_VERSION`

### 2. On-Demand Backup (Local)

In addition to the automated backup, this project also supports on-demand backups that can be triggered locally. This is useful when you need to create a backup at a specific point in time, outside the regular schedule.

#### Example Command:

To run an on-demand backup locally, use the following command:

    restic backup /path/to/data --tags on-demand --tags vaultwarden:$VAULTWARDEN_VERSION

https://github.com/tryrocket-cloud/tryrocket-cloud/issues/48

### Kopia

https://github.com/tryrocket-cloud/tryrocket-cloud/issues/49

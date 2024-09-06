# vaultwarden

## Datasheet

- replica 
- where is the backup
- how many backups
- where is the doc how to restore


## todo

- install github runner
- run action to stop vw
- run action to snapshot volumes
  - vaultwarden
  - postgres
- run action to backup volumes
- run action to backup data
- run action to sync vw app


## Prerequisites

### Production

- create longhorn volume for postgres
- create longhorn volume for vaultwarden
- create a superuser password in vault for postgres database
- create <vault user> and <app user> in the database
- create Vault database connection and static role


- create database user
- create a new database with this new user and matching the creds in deployment

## Install

    # Argo CD Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/production/application.yaml -n argocd

    # Argo CD Preview Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/preview/application-set.yaml -n argocd

## Update

```mermaid
sequenceDiagram
    participant GitHub Action
    participant ArgoCD
    participant Router
    participant Human Reviewer
    participant Backup

    GitHub Action->>GitHub Action: Check for new Vaultwarden release (weekly)
    alt New Release Detected
        GitHub Action->>GitHub Action: Create PR with updated Docker tag
        GitHub Action->>ArgoCD: Deploy preview environment
        ArgoCD->>Backup: Get latest backup data
        Backup-->>ArgoCD: latest backup snapshot
        GitHub Action->>Router: Setup DNS entry for preview URL
        Router-->>Human Reviewer: Preview app available at specific URL
        Human Reviewer->>Human Reviewer: Review changes and test new release
        Human Reviewer->>GitHub Action: Approve and merge PR
        ArgoCD->>ArgoCD: Destroy to production environment
        GitHub Action->>Router: Remove DNS entry
    else No New Release
        GitHub Action-->>GitHub Action: No action taken
    end
```

## Snapshots & Backup 

[General information about backups](https://github.com/tryrocket-cloud/tryrocket-cloud/wiki/Backup)

- Longhorn Volume Snapshots: 0 0,12 * * *
- Longhorn Volume Backup: 0 3 * * 0
- Raw Data: 0 3 * * *

| **Task**                    | **Cron Schedule**    | **Description**                                         |
|-----------------------------|----------------------|---------------------------------------------------------|
| Longhorn Volume Snapshots| `0 0,12 * * *`       | Runs at 00:00 and 12:00 every day                       |
| Longhorn Volume Backup   | `0 3 * * 0`          | Runs at 03:00 every Sunday                              |
| Raw Data Backup          | `0 3 * * *`          | Runs at 03:00 every day                                 |



### Configuration:

- [CronJob](./overlays/production/backup/backup-cronjob.yaml)

## Vaultwarden in HA mode (currently not possible)

- https://vaultwarden.discourse.group/t/running-highly-available-vaultwarden/3285


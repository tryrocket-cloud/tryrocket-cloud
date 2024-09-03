# vaultwarden

## Datasheet

- replica 
- where is the backup
- how many backups
- where is the doc how to restore


## todo
- create database for vaultwarden

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

- create database user
- create a new database with this new user and matching the creds in deployment

### Staging

no prerequisites needed

### Testing

no prerequisites needed

## Install 

    just app-deploy vaultwarden production

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

## Backup

https://github.com/tryrocket-cloud/tryrocket-cloud/wiki/Backup

### Restic

### 1. Automated Backup (`tryrocket.cloud`)

The automated backup process is configured to run regularly in a k3s cluster. This process ensures that critical data is backed up at `0 3 * * *` (*at 03:00 o'clock*) without requiring any manual intervention.

#### Configuration:

- [CronJob](./overlays/production/backup/backup-cronjob.yaml)

### 2. On-Demand Backup (Local)

In addition to the automated backup, this project also supports on-demand backups that can be triggered locally. This is useful when you need to create a backup at a specific point in time, outside the regular schedule.

#### Example Command:

To run an on-demand backup locally, use the following command:

    restic backup /path/to/data --tags on-demand --tags vaultwarden:$VAULTWARDEN_VERSION

https://github.com/tryrocket-cloud/tryrocket-cloud/issues/48

## Vaultwarden in HA mode (currently not possible)

- https://vaultwarden.discourse.group/t/running-highly-available-vaultwarden/3285


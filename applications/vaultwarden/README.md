# vaultwarden

## TODO

- add longhorn-volumes as k8s manifests
- add longhorn recurring tasks for snapshot an backup
- backup-cronjob inhertitance

## Prerequisites

- [External Secrets Operator](https://external-secrets.io/latest/) is installed

- [Vault](https://www.vaultproject.io/) is installed and configured

- Create Vaultwarden kubernetes role Vault

      vault write auth/kubernetes/role/vaultwarden \
          bound_service_account_names=vaultwarden-vault-sa \
          bound_service_account_namespaces=vaultwarden \
          policies=vaultwarden \
          ttl=24h

- Create Vaultwarden policy in Vault ([vaultwarden-policy.hcl](/applications/vaultwarden/overlays/production/vaultwarden-policy.hcl))
    
      vault policy write vaultwarden vaultwarden-policy.hcl

## Install

    kubectl create namespace vaultwarden

    # Argo CD Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/production/application.yaml -n argocd

    # Argo CD Preview Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/vaultwarden/overlays/preview/application-set.yaml -n argocd

    # Backup is managed manually due to high risk of loosing all backups dur to argo autosync
    kubectl apply -k https://github.com/tryrocket-cloud/tryrocket-cloud//applications/vaultwarden/overlays/backup

    kubectl get backups.velero.io -n velero
    

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

### Vaultwarden Backup and Snapshot Strategy

| Schedule | Action | Details | Destination(s)|
|---|---|---|---|
| **Daily (30 0 * * *)** | Vaultwarden export and backup | Export Vaultwarden data and back it up using Restic | Hetzner.com, Ionos.com (EU Central 1 & EU Central 3) |
| **Daily (0 0 * * *)** | Longhorn volume snapshot |  | Local (Longhorn) |
| **Weekly (30 0 * * 0)** | Longhorn volume backup to TrueNAS | Backup Longhorn volumes to external TrueNAS storage | TrueNAS |
| **Weekly (30 0 * * 0)**       | Restore from Longhorn backup and perform full Restic backup | Restore a new volume from Longhorn backup and perform full backup using Restic | Hetzner.com, Ionos.com (EU Central 1 & EU Central 3) |



  - [Vaultwarden Data Volume](../../infrastructure/longhorn/test-volume.yaml) 
  - [Postgres Data Volume](../../infrastructure/longhorn/test-volume.yaml)

  [#74](https://github.com/tryrocket-cloud/tryrocket-cloud/issues/74)

- Longhorn Volumes Snapshots

       `0 0,12 * * *`

- Longhorn Volumes Backups 
  
      `15 0 * * 0`

- Raw data

    [CronJob]((./overlays/production/backup/backup-cronjob.yaml))


## Vaultwarden in HA mode (currently not possible)

- https://vaultwarden.discourse.group/t/running-highly-available-vaultwarden/3285


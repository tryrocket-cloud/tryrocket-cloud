# Velero

# Notes

- BackupRepository will be generated from BackupStorageLocation

# TODO

- backup - paths ionos
- ionos profile with acl
- kopia configuration? like prune and co.
- stop vaultwarden before update, maybe backup hooks?


## Install
    
    # Argo CD Application
    kubectl apply -f https://raw.githubusercontent.com/tryrocket-cloud/tryrocket-cloud/main/applications/velero/application.yaml -n argocd

## Links

- https://github.com/cloudogu/velero-longhorn-demo/blob/main/README_en.md
- https://platform.cloudogu.com/de/blog/velero-longhorn-backup-restore/



## Debug


kubectl get volumesnapshotclass
kubectl get volumesnapshotcontent -n vaultwarden
kubectl get volumesnapshot -n vaultwarden


## Manual Test

Should create snapshots and delete snapshots

kubectl apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: test-snapshot
  namespace: vaultwarden
spec:
  volumeSnapshotClassName: longhorn-snapshot-vsc
  source:
    persistentVolumeClaimName: vaultwarden-test-pvc
EOF

kubectl get volumesnapshotcontent -n vaultwarden
kubectl get volumesnapshot -n vaultwarden
kubectl delete volumesnapshot test-snapshot -n vaultwarden


## get csi versions of crds

kubectl get crds | grep volumesnapshot

volumesnapshotclasses.snapshot.storage.k8s.io           2024-09-15T20:14:41Z
volumesnapshots.snapshot.storage.k8s.io                 2024-09-15T20:14:52Z
volumesnapshotcontents.snapshot.storage.k8s.io          2024-09-15T20:15:06Z
volumesnapshotlocations.velero.io                       2024-09-13T21:52:18Z


## Commands

run backup create without snapshots
    velero backup create vaultwarden-backup-nosnap1 --include-namespaces vaultwarden --snapshot-volumes=false --wait

run backup create with snapshots
    velero backup create vaultwarden-backup-nosnap1 --include-namespaces vaultwarden --snapshot-volumes --wait
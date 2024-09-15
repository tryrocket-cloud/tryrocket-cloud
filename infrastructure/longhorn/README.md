# longhorn

## Notes

- by two nodes `numberOfReplicas` should be two
- kubectl -n longhorn-system edit cm longhorn-storageclass
- adjust 'Default Replica Count' to number of nodes
- activate v2 data engine
    - enable hugepages


## CSI crds and snapsshot controller

https://longhorn.io/docs/1.6.2/snapshots-and-backups/csi-snapshot-support/enable-csi-snapshot-support/

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.3.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.3.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.3.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.3.2/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.3.2/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

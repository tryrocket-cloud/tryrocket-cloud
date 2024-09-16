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


# mount specific snapshot as pvc?
https://longhorn.io/docs/1.7.1/snapshots-and-backups/csi-snapshot-support/csi-volume-snapshot-associated-with-longhorn-snapshot/


# https://longhorn.io/docs/1.7.1/snapshots-and-backups/csi-snapshot-support/csi-volume-snapshot-associated-with-longhorn-snapshot/
kind: VolumeSnapshotClass
apiVersion: snapshot.storage.k8s.io/v1
metadata:
  name: longhorn-snapshot-vsc
  labels:
    velero.io/csi-volumesnapshot-class: "true"
driver: driver.longhorn.io
deletionPolicy: Delete
parameters:
  type: snap


# https://longhorn.io/docs/1.7.1/snapshots-and-backups/csi-snapshot-support/csi-volume-snapshot-associated-with-longhorn-backup/
kind: VolumeSnapshotClass
apiVersion: snapshot.storage.k8s.io/v1
metadata:
  name: longhorn-snapshot-vsc
  labels:
    # https://velero.io/docs/v1.14/csi/#implementation-choices
    velero.io/csi-volumesnapshot-class: "true"
driver: driver.longhorn.io
deletionPolicy: Delete
parameters:
  type: bak
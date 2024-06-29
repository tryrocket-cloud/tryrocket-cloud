# longhorn

## Notes

- by two nodes `numberOfReplicas` should be two
- kubectl -n longhorn-system edit cm longhorn-storageclass
- adjust 'Default Replica Count' to number of nodes
- activate v2 data engine
    - enable hugepages
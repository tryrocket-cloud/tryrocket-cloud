# truenas

Open k3s 
`iptables -I INPUT -p tcp -s YOUR-IP --dport 6443 -j ACCEPT -m comment --comment 'Allow kubectl access from remote computer' --wait`

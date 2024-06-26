# truenas

Open k3s 
  
    iptables -I INPUT -p tcp -s YOUR-IP --dport 6443 -j ACCEPT -m comment --comment 'Allow kubectl access from remote computer' --wait

## Links

- https://gist.github.com/indrekj/8a8121b4964a56cdbb5f6f71d3319457

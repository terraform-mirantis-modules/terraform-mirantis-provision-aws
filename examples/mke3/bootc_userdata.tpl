#cloud-config
users:
  - name: cloud-user
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: docker
    ssh_authorized_keys:
      - ${public_key}

write_files:
  - path: /etc/modules-load.d/xt_statistic.conf
    permissions: '0644'
    content: |
      xt_statistic

runcmd:
  - usermod -aG docker cloud-user
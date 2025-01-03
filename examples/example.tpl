#cloud-config
write_files:
  - path: /tmp/hello.txt
    content: |
      ${cloudconfig}

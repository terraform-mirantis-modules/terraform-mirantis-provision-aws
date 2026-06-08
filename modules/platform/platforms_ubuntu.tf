locals {
  lib_platforms_ubuntu = {
    "ubuntu_16.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_18.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_20.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_22.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_24.04" : {
      "ami_name" : "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
    "ubuntu_24" : {
      "ami_name" : "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*",
      "owner" : "099720109477",
      "interface" : "ens5"
      "connection" : "ssh",
      "ssh_user" : "ubuntu",
      "ssh_port" : 22
    },
  }
}

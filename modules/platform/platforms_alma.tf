locals {
  lib_platforms_alma = {
    "alma_8" : {
      "ami_name" : "AlmaLinux OS 8.* x86_64",
      "owner" : "764336703387",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "alma_9" : {
      "ami_name" : "AlmaLinux OS 9.* x86_64",
      "owner" : "764336703387",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "alma_10" : {
      "ami_name" : "AlmaLinux OS 10.* x86_64",
      "owner" : "764336703387",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
  }
}

locals {
  lib_platforms_centos = {
    "centos_7" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "CentOS Linux 7 x86_64*",
      "owner" : "125523088429",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "centos",
      "ssh_port" : 22
    },
    "centos_7.9" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "CentOS Linux 7 x86_64*",
      "owner" : "125523088429",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "centos",
      "ssh_port" : 22
    },
    "centos_stream_9" : {
      "ami_name" : "CentOS Stream 9 x86_64 *",
      "owner" : "125523088429",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "centos_stream_10" : {
      "ami_name" : "CentOS Stream 10 x86_64 *",
      "owner" : "125523088429",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
  }
}

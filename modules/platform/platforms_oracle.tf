// WARNING: Owner 131827586825 (Oracle) publishes ZERO AMIs in us-east-1 as of 2026-06.
// All entries below resolve to 0 AMIs. No first-party Oracle replacement with the OL*-HVM
// naming scheme is currently available in this region. Entries are retained for reference
// and for potential use in other regions where Oracle may still publish.
locals {
  lib_platforms_oracle = {
    "oracle_7" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL7.?-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_7.6" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL7.6-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_7.8" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL7.8-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_7.9" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL7.9-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_8.2" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL8.2-x86_64-HVM-2020-05-22",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_8.3" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL8.3-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_8.6" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL8.6-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_9.0" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL9.0-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_9.1" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL9.1-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_9.2" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL9.2-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "oracle_9" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "OL9.2-x86_64-HVM-*",
      "owner" : "131827586825",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
  }
}

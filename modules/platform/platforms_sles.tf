locals {
  lib_platforms_sles = {
    "sles_12" : {
      "ami_name" : "suse-sles-12-sp?-v????????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_12_sp4" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-12-sp4-v????????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_12_sp5" : {
      "ami_name" : "suse-sles-12-sp5-v????????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_12sp5" : {
      "ami_name" : "suse-sles-12-sp5-v????????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15" : {
      "ami_name" : "suse-sles-15-sp?-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15_sp1" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp1-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15_sp2" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp2-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp2" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp2-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15_sp3" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp3-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp3" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp3-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp4" : { // no AMIs available in us-east-1 as of 2026-06
      "ami_name" : "suse-sles-15-sp4-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp5" : {
      "ami_name" : "suse-sles-15-sp5-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp6" : {
      "ami_name" : "suse-sles-15-sp6-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15_sp6" : {
      "ami_name" : "suse-sles-15-sp6-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15sp7" : {
      "ami_name" : "suse-sles-15-sp7-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_15_sp7" : {
      "ami_name" : "suse-sles-15-sp7-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "sles_16" : {
      "ami_name" : "suse-sles-16-0-v20??????-hvm-ssd-x86_64",
      "owner" : "013907871322",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
  }
}

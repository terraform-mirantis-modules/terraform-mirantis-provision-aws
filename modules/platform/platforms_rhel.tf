locals {
  lib_platforms_rhel = {
    "rhel_7" : {
      "ami_name" : "RHEL-7.?_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_7.5" : {
      "ami_name" : "RHEL-7.5_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_7.6" : {
      "ami_name" : "RHEL-7.6_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_7.7" : {
      "ami_name" : "RHEL-7.7_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_7.8" : {
      "ami_name" : "RHEL-7.8_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_7.9" : {
      "ami_name" : "RHEL-7.9_HVM*x86_64*Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.0" : {
      "ami_name" : "RHEL-8.0_HVM-201?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.1" : {
      "ami_name" : "RHEL-8.1.0_HVM-201?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.2" : {
      "ami_name" : "RHEL-8.2_HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.3" : {
      "ami_name" : "RHEL-8.3*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.4" : {
      "ami_name" : "RHEL-8.4*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.5" : {
      "ami_name" : "RHEL-8.5*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.6" : {
      "ami_name" : "RHEL-8.6*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.7" : {
      "ami_name" : "RHEL-8.7*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.8" : {
      "ami_name" : "RHEL-8.8*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.9" : {
      "ami_name" : "RHEL-8.9.?_HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8.10" : {
      "ami_name" : "RHEL-8.10.?_HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_8" : {
      "ami_name" : "RHEL-8.10.?_HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.0" : {
      "ami_name" : "RHEL-9.0*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.1" : {
      "ami_name" : "RHEL-9.1*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.2" : {
      "ami_name" : "RHEL-9.2*HVM-202?????-x86_64-*-Hourly2-GP2",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.3" : {
      "ami_name" : "RHEL-9.3*HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.4" : {
      "ami_name" : "RHEL-9.4*HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9.5" : {
      "ami_name" : "RHEL-9.5*HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
    "rhel_9" : {
      "ami_name" : "RHEL-9.4*HVM-202?????-x86_64-*-Hourly2-GP?",
      "owner" : "309956199498",
      "interface" : "eth0"
      "connection" : "ssh",
      "ssh_user" : "ec2-user",
      "ssh_port" : 22
    },
  }
}

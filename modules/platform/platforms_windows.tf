locals {
  lib_platforms_windows = {
    "windows_2019" : {
      "ami_name" : "Windows_Server-2019-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_core_2019" : {
      "ami_name" : "Windows_Server-2019-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_full_2019" : {
      "ami_name" : "Windows_Server-2019-English-Full-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_2022" : {
      "ami_name" : "Windows_Server-2022-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_core_2022" : {
      "ami_name" : "Windows_Server-2022-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_full_2022" : {
      "ami_name" : "Windows_Server-2022-English-Full-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_2025" : {
      "ami_name" : "Windows_Server-2025-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_core_2025" : {
      "ami_name" : "Windows_Server-2025-English-Core-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
    "windows_full_2025" : {
      "ami_name" : "Windows_Server-2025-English-Full-Base-*",
      "owner" : "801119661308",
      "interface" : "Ethernet 3"
      "connection" : "winrm",
      "winrm_user" : "Administrator",
      "winrm_useHTTPS" : true
      "winrm_insecure" : true
    },
  }
}

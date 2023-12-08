project_name = "t-clo-901-mpl-2"
vm_name = [
  {
    name     = "webappepi",
    username = "userwebapp"
    notes    = "webapp server"
  },
  {
    name     = "sqldb"
    username = "userdb"
    notes    = "db server"
  }
]
size         = "Standard_A4_v2"
storage_type = "Standard"
offer        = "0001-com-ubuntu-server-jammy"
publisher    = "canonical"
sku          = "22_04-lts"
os_version   = "latest"
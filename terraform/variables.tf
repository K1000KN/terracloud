variable "project_name" {
  description = "nom du project"
  type        = string
}

variable "vm_name" {
  description = "name of the vm"
  type        = list(any)
}

variable "size" {
  description = "size of the vm"
  type        = string
}

variable "storage_type" {
  description = "storage type of the vm"
  type        = string
}

variable "offer" {
  description = "azure offer"
  type        = string

}

variable "publisher" {
  description = "name of the publisher of the distro"
  type        = string
}

variable "sku" {
  description = "version of the distro"
  type        = string
}

variable "os_version" {
  description = "version of the vm"
  type        = string
}
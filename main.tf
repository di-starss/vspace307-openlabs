/**

    $ OPENLABS, v.2.0 2021/10/11 12:36 Exp @di $

    ENV___
          export TF_VAR_qemu_ip={ip}

          export TF_VAR_nbx_server_url={url}
          export TF_VAR_nbx_api_token={api_token}
          export TF_VAR_nbx_allow_insecure_https=false

          export TF_VAR_dns_server_url={url}
          export TF_VAR_dns_api_key={api_token}

    CFG___
          variable "qemu_ip" {}

          variable "nbx_server_url" {}
          variable "nbx_api_token" {}
          variable "nbx_allow_insecure_https" {}

          variable "dns_server_url" {}
          variable "dns_api_key" {}

          variable "consul_host" { default = "consul.openlabs.vspace307.io" }
          variable "consul_port" { default = 8500 }
          variable "consul_schema" { default = "http" }

          locals {
            consul_url = "${var.consul_schema}://${var.consul_host}:${var.consul_port}"
          }

          provider "libvirt" {
            uri = "qemu+tcp://root@${var.qemu_ip}/system"
          }

          provider "netbox" {
            server_url           = var.nbx_server_url
            api_token            = var.nbx_api_token
            allow_insecure_https = var.nbx_allow_insecure_https
          }

          provider "powerdns" {
            server_url  = var.dns_server_url
            api_key     = var.dns_api_key
          }

          provider "consul" {
            address    = local.consul_url
            datacenter = var.consul_dc
          }

    RUN___
          ulimit -n 4096
          terraform apply -parallelism=60
**/

terraform {
  required_version = ">= 0.14.0"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.6.11"
    }
    netbox = {
      source = "e-breuninger/netbox"
      version = "0.2.2"
    }
    powerdns = {
      source = "ag-TJNII/powerdns"
      version = "101.6.1"
    }
    consul = {
      source = "hashicorp/consul"
      version = "2.13.0"
    }
  }
}

//
// USER
// ---------------------------------------------------------------------------------------------------------------------
/*
  variable "env" { default = "di" }

  variable "mgmt_user" { default = "mgmt" }
  variable "mgmt_public_key" { default = "~/.ssh/id_rsa.pub" }
  variable "mgmt_private_key" { default = "~/.ssh/id_rsa" }
*/

variable "env" {}

variable "mgmt_user" {}
variable "mgmt_public_key" {}
variable "mgmt_private_key" {}

locals {
  mgmt_public_key = file(var.mgmt_public_key)
  mgmt_private_key = file(var.mgmt_private_key)
}

//
// OPENSTACK
//
/*
  variable "openstack_release" { default = "victoria" }
  variable "openstack_keystone_bootstrap_password" { default = "{password}" }
  variable "openstack_neutron_metadata_proxy_shared_secret" { default = "{password}" }

  variable "openstack_mgmt_user" { default = "mgmt" }
  variable "openstack_mgmt_password" { default = "{password}" }

  variable "openstack_service_glance_password" { default = "{password}" }
  variable "openstack_service_nova_password" { default = "{password}" }
  variable "openstack_service_placement_password" { default = "{password}" }
  variable "openstack_service_neutron_password" { default = "{password}" }
  variable "openstack_service_cinder_password" { default = "{password}" }

  variable "openstack_db_root_password" { default = "{password}" }
  variable "openstack_db_mgmt_password" { default = "{password}" }

  variable "openstack_db_keystone_password" { default = "{password}" }
  variable "openstack_db_glance_password" { default = "{password}" }
  variable "openstack_db_nova_password" { default = "{password}" }
  variable "openstack_db_placement_password" { default = "{password}" }
  variable "openstack_db_neutron_password" { default = "{password}" }
  variable "openstack_db_cinder_password" { default = "{password}" }

  variable "openstack_mq_user" { default = "openlabs" }
  variable "openstack_mq_password" { default = "{password}" }

  variable "openstack_rsyslog_logdna_key" { default = "{api_token}" }

  variable "openlabs_consul_host" { default = "consul.openlabs.vspace307.io" }
  variable "openlabs_consul_port" { default = 8500 }
  variable "openlabs_consul_schema" { default = "http" }
  variable "openlabs_consul_dc" { default = "rg1" }

  variable "img_source" { default = "http://{ip}/focal-server-cloudimg-amd64-100-zip.img" }
  variable "img_name" { default = "focal-64-cloud-init-100" }

*/

variable "openstack_release" {}

variable "openstack_keystone_bootstrap_password" {}
variable "openstack_neutron_metadata_proxy_shared_secret" {}

variable "openstack_endpoint_schema" { default = "http" }

variable "openstack_mgmt_user" {}
variable "openstack_mgmt_password" {}

variable "openstack_service_glance_user" { default = "glance" }
variable "openstack_service_nova_user" { default = "nova" }
variable "openstack_service_placement_user" { default = "placement" }
variable "openstack_service_neutron_user" { default = "neutron" }
variable "openstack_service_cinder_user" { default = "cinder" }

variable "openstack_service_glance_password" {}
variable "openstack_service_nova_password" {}
variable "openstack_service_placement_password" {}
variable "openstack_service_neutron_password" {}
variable "openstack_service_cinder_password" {}

variable "openstack_endpoint_keystone_port" { default = 5000 }
variable "openstack_endpoint_glance_port" { default = 9292 }
variable "openstack_endpoint_nova_port" { default = 8774 }
variable "openstack_endpoint_placement_port" { default = 8778 }
variable "openstack_endpoint_neutron_port" { default = 9696 }
variable "openstack_endpoint_cinder_port" { default = 8776 }

variable "openstack_db_root_password" {}
variable "openstack_db_mgmt_password" {}

variable "openstack_db_keystone_user" { default = "keystone" }
variable "openstack_db_keystone_password" {}

variable "openstack_db_glance_user" { default = "glance" }
variable "openstack_db_glance_password" {}

variable "openstack_db_nova_user" { default = "nova" }
variable "openstack_db_nova_password" {}

variable "openstack_db_placement_user" { default = "placement" }
variable "openstack_db_placement_password" {}

variable "openstack_db_neutron_user" { default = "neutron" }
variable "openstack_db_neutron_password" {}

variable "openstack_db_cinder_user" { default = "cinder" }
variable "openstack_db_cinder_password" {}

variable "openstack_db_keystone" { default = "keystone" }
variable "openstack_db_glance" { default = "glance" }
variable "openstack_db_nova" { default = "nova" }
variable "openstack_db_nova_api" { default = "nova_api" }
variable "openstack_db_nova_cell" { default = "nova_cell0" }
variable "openstack_db_placement" { default = "placement" }
variable "openstack_db_neutron" { default = "neutron" }
variable "openstack_db_cinder" { default = "cinder" }

variable "openstack_mq_user" {}
variable "openstack_mq_password" {}

variable "openstack_memcached_port" { default = 11211 }

variable "openstack_compute_ovs_if" { default = "ens4" }
variable "openstack_network_ovs_if" { default = "ens4" }

variable "openstack_rsyslog_logdna_key" {}

//
// VM
//
variable "openlabs_consul_host" {}
variable "openlabs_consul_port" {}
variable "openlabs_consul_schema" {}
variable "openlabs_consul_dc" {}

variable "ansible_playbook_mgmt" { default = "mgmt.yaml" }
variable "ansible_playbook_controller" { default = "controller.yaml" }
variable "ansible_playbook_network" { default = "network.yaml" }
variable "ansible_playbook_storage" { default = "storage.yaml" }
variable "ansible_playbook_compute" { default = "compute.yaml" }

variable "img_source" {}
variable "img_name" {}

variable "volume_path_img" { default = "/data/openlabs/img" }
variable "volume_path_pool" { default = "/data/openlabs/instance" }

variable "dns_ns1" { default = "172.21.17.17" }

/**
    ___________   VCPU  RAM __
    mgmt          1     2
    controller    8     12
    net           4     8
    pure          8     16
    kvm           8     16
    --------------------------

**/
variable "vm_mgmt_vcpu" { default = 1 }
variable "vm_mgmt_ram" { default = 2 }

variable "vm_controller_vcpu" { default = 10 }
variable "vm_controller_ram" { default = 24 }

variable "vm_net_vcpu" { default = 4 }
variable "vm_net_ram" { default = 8 }

variable "vm_sd_vcpu" { default = 4 }
variable "vm_sd_ram" { default = 8 }

variable "vm_kvm_vcpu" { default = 12 }
variable "vm_kvm_ram" { default = 24 }

variable "vm_if_mgmt_rg" {
  type = map
  default = {

    interfaces = [
      {
        network = "vnetOVS",
        portgroup = "OPENLABS_CLOUD_MGMT_RG",
        type = "virtio"
      }
    ]
  }
}

variable "vm_if_all_ams" {
  type = map
  default = {

    interfaces = [
      {
        network = "vnetOVS",
        portgroup = "OPENLABS_CLOUD_MGMT_AMS",
        type = "virtio"
      },
      {
        network = "vnetOVS",
        portgroup = "OPENLABS_CLOUD_TRUNK_AMS",
        type = "virtio"
      }
    ]
  }
}

variable "vm_if_all_ldn" {
  type = map
  default = {

    interfaces = [
      {
        network = "vnetOVS",
        portgroup = "OPENLABS_CLOUD_MGMT_LDN",
        type = "virtio"
      },
      {
        network = "vnetOVS",
        portgroup = "OPENLABS_CLOUD_TRUNK_LDN",
        type = "virtio"
      }
    ]
  }
}

//
// CORE
//
module "core" {
  source = "github.com/di-starss/vspace307-openlabs-core"
  env = var.env
}


//
// KV
//
resource "consul_key_prefix" "config" {
  path_prefix = "${module.core.project}/${var.env}/openstack/"

  subkeys = {
    "openstack_release" = var.openstack_release

    "openstack_vm_endpoint" = module.core.vm_rg_controller_hostname
    "openstack_vm_db" = module.core.vm_rg_controller_hostname
    "openstack_vm_cache" = module.core.vm_rg_controller_hostname
    "openstack_vm_mq" = module.core.vm_rg_controller_hostname

    "openstack_vm_ams_kvm0" = module.core.vm_ams_compute_kvm0_hostname
    "openstack_vm_ams_kvm1" = module.core.vm_ams_compute_kvm1_hostname
    "openstack_vm_ams_kvm2" = module.core.vm_ams_compute_kvm2_hostname
    "openstack_vm_ldn_kvm3" = module.core.vm_ldn_compute_kvm3_hostname
    "openstack_vm_ldn_kvm4" = module.core.vm_ldn_compute_kvm4_hostname
    "openstack_vm_ldn_kvm5" = module.core.vm_ldn_compute_kvm5_hostname

    "openstack_compute_ovs_if" = var.openstack_compute_ovs_if
    "openstack_network_ovs_if" = var.openstack_network_ovs_if

    "openstack_endpoint_schema" = var.openstack_endpoint_schema

    "openstack_keystone_bootstrap_password" = var.openstack_keystone_bootstrap_password
    "openstack_neutron_metadata_proxy_shared_secret" = var.openstack_neutron_metadata_proxy_shared_secret

    "openstack_mgmt_user" = var.openstack_mgmt_user
    "openstack_mgmt_password" = var.openstack_mgmt_password

    "openstack_endpoint_keystone_port" = var.openstack_endpoint_keystone_port
    "openstack_endpoint_glance_port" = var.openstack_endpoint_glance_port
    "openstack_endpoint_nova_port" = var.openstack_endpoint_nova_port
    "openstack_endpoint_placement_port" = var.openstack_endpoint_placement_port
    "openstack_endpoint_neutron_port" = var.openstack_endpoint_neutron_port
    "openstack_endpoint_cinder_port" = var.openstack_endpoint_cinder_port

    "openstack_service_glance_user" = var.openstack_service_glance_user
    "openstack_service_nova_user" = var.openstack_service_nova_user
    "openstack_service_placement_user" = var.openstack_service_placement_user
    "openstack_service_neutron_user" = var.openstack_service_neutron_user
    "openstack_service_cinder_user" = var.openstack_service_cinder_user

    "openstack_service_glance_password" = var.openstack_service_glance_password
    "openstack_service_nova_password" = var.openstack_service_nova_password
    "openstack_service_placement_password" = var.openstack_service_placement_password
    "openstack_service_neutron_password" = var.openstack_service_neutron_password
    "openstack_service_cinder_password" = var.openstack_service_cinder_password

    "openstack_db_root_password" = var.openstack_db_root_password

    "openstack_db_mgmt_user" = var.env
    "openstack_db_mgmt_password" = var.openstack_db_mgmt_password

    "openstack_db_keystone_user" = var.openstack_db_keystone_user
    "openstack_db_keystone_password" = var.openstack_db_keystone_password

    "openstack_db_glance_user" = var.openstack_db_glance_user
    "openstack_db_glance_password" = var.openstack_db_glance_password

    "openstack_db_nova_user" = var.openstack_db_nova_user
    "openstack_db_nova_password" = var.openstack_db_nova_password

    "openstack_db_placement_user" = var.openstack_db_placement_user
    "openstack_db_placement_password" = var.openstack_db_placement_password

    "openstack_db_neutron_user" = var.openstack_db_neutron_user
    "openstack_db_neutron_password" = var.openstack_db_neutron_password

    "openstack_db_cinder_user" = var.openstack_db_cinder_user
    "openstack_db_cinder_password" = var.openstack_db_cinder_password

    "openstack_db_keystone" = var.openstack_db_keystone
    "openstack_db_glance" = var.openstack_db_glance
    "openstack_db_nova" = var.openstack_db_nova
    "openstack_db_nova_api" = var.openstack_db_nova_api
    "openstack_db_nova_cell" = var.openstack_db_nova_cell
    "openstack_db_placement" = var.openstack_db_placement
    "openstack_db_neutron" = var.openstack_db_neutron
    "openstack_db_cinder" = var.openstack_db_cinder

    "openstack_mq_user" = var.openstack_mq_user
    "openstack_mq_password" = var.openstack_mq_password

    "openstack_memcached_port" = var.openstack_memcached_port

    "openstack_rsyslog_logdna_key" = var.openstack_rsyslog_logdna_key
  }
}

module "img" {
  source = "github.com/di-starss/vspace307-openlabs-qemu-img"

  env = var.env
  img_name = var.img_name
  img_path = var.volume_path_img
  img_source = var.img_source
}

//
// RG
//
module "vm_controller" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img
  ]

  vm_name = module.core.vm_rg_controller_name
  vm_fqdn = module.core.vm_rg_controller_fqdn
  vm_hostname = module.core.vm_rg_controller_hostname
  vm_ip = module.core.vm_rg_controller_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_controller

  env = module.core.env
  site = module.core.site_rg
  project = module.core.project
  service = module.core.service_controller

  vm_vcpu = var.vm_controller_vcpu
  vm_ram = var.vm_controller_ram
  vm_subnet = module.core.subnet_rg_cloud_mgmt
  vm_if = var.vm_if_mgmt_rg
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

//
// AMS
//
module "vm_ams_kvm0" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ams_compute_kvm0_name
  vm_fqdn = module.core.vm_ams_compute_kvm0_fqdn
  vm_hostname = module.core.vm_ams_compute_kvm0_hostname
  vm_ip = module.core.vm_ams_compute_kvm0_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_kvm1" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ams_compute_kvm1_name
  vm_fqdn = module.core.vm_ams_compute_kvm1_fqdn
  vm_hostname = module.core.vm_ams_compute_kvm1_hostname
  vm_ip = module.core.vm_ams_compute_kvm1_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_kvm2" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ams_compute_kvm2_name
  vm_fqdn = module.core.vm_ams_compute_kvm2_fqdn
  vm_hostname = module.core.vm_ams_compute_kvm2_hostname
  vm_ip = module.core.vm_ams_compute_kvm2_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_sd_rack_5" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ams_sd_rack_5_name
  vm_fqdn = module.core.vm_ams_sd_rack_5_fqdn
  vm_hostname = module.core.vm_ams_sd_rack_5_hostname
  vm_ip = module.core.vm_ams_sd_rack_5_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_storage

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_storage

  vm_vcpu = var.vm_sd_vcpu
  vm_ram = var.vm_sd_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 200

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_sd_rack_6" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ams_sd_rack_6_name
  vm_fqdn = module.core.vm_ams_sd_rack_6_fqdn
  vm_hostname = module.core.vm_ams_sd_rack_6_hostname
  vm_ip = module.core.vm_ams_sd_rack_6_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_storage

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_storage

  vm_vcpu = var.vm_sd_vcpu
  vm_ram = var.vm_sd_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 200

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_network_gw0" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ams_net_gw0_name
  vm_fqdn = module.core.vm_ams_net_gw0_fqdn
  vm_hostname = module.core.vm_ams_net_gw0_hostname
  vm_ip = module.core.vm_ams_net_gw0_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_network

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_storage

  vm_vcpu = var.vm_net_vcpu
  vm_ram = var.vm_net_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ams_network_gw1" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ams_net_gw1_name
  vm_fqdn = module.core.vm_ams_net_gw1_fqdn
  vm_hostname = module.core.vm_ams_net_gw1_hostname
  vm_ip = module.core.vm_ams_net_gw1_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_network

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_network

  vm_vcpu = var.vm_net_vcpu
  vm_ram = var.vm_net_ram
  vm_subnet = module.core.subnet_ams_cloud_mgmt
  vm_if = var.vm_if_all_ams
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

//
// LDN
//
module "vm_ldn_kvm3" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ldn_compute_kvm3_name
  vm_fqdn = module.core.vm_ldn_compute_kvm3_fqdn
  vm_hostname = module.core.vm_ldn_compute_kvm3_hostname
  vm_ip = module.core.vm_ldn_compute_kvm3_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ldn
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ldn_kvm4" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ldn_compute_kvm4_name
  vm_fqdn = module.core.vm_ldn_compute_kvm4_fqdn
  vm_hostname = module.core.vm_ldn_compute_kvm4_hostname
  vm_ip = module.core.vm_ldn_compute_kvm4_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ldn
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ldn_kvm5" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller
  ]

  vm_name = module.core.vm_ldn_compute_kvm5_name
  vm_fqdn = module.core.vm_ldn_compute_kvm5_fqdn
  vm_hostname = module.core.vm_ldn_compute_kvm5_hostname
  vm_ip = module.core.vm_ldn_compute_kvm5_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_compute

  env = module.core.env
  site = module.core.site_ldn
  project = module.core.project
  service = module.core.service_compute

  vm_vcpu = var.vm_kvm_vcpu
  vm_ram = var.vm_kvm_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ldn_sd_rack_17" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ldn_sd_rack_17_name
  vm_fqdn = module.core.vm_ldn_sd_rack_17_fqdn
  vm_hostname = module.core.vm_ldn_sd_rack_17_hostname
  vm_ip = module.core.vm_ldn_sd_rack_17_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_storage

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_storage

  vm_vcpu = var.vm_sd_vcpu
  vm_ram = var.vm_sd_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 200

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ldn_sd_rack_18" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ldn_sd_rack_18_name
  vm_fqdn = module.core.vm_ldn_sd_rack_18_fqdn
  vm_hostname = module.core.vm_ldn_sd_rack_18_hostname
  vm_ip = module.core.vm_ldn_sd_rack_18_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_storage

  env = module.core.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_storage

  vm_vcpu = var.vm_sd_vcpu
  vm_ram = var.vm_sd_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 200

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}


module "vm_ldn_network_gw0" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ldn_net_gw0_name
  vm_fqdn = module.core.vm_ldn_net_gw0_fqdn
  vm_hostname = module.core.vm_ldn_net_gw0_hostname
  vm_ip = module.core.vm_ldn_net_gw0_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_network

  env = module.core.env
  site = module.core.site_ldn
  project = module.core.project
  service = module.core.service_network

  vm_vcpu = var.vm_net_vcpu
  vm_ram = var.vm_net_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

module "vm_ldn_network_gw1" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,
    module.img,
    module.vm_controller,
  ]

  vm_name = module.core.vm_ldn_net_gw1_name
  vm_fqdn = module.core.vm_ldn_net_gw1_fqdn
  vm_hostname = module.core.vm_ldn_net_gw1_hostname
  vm_ip = module.core.vm_ldn_net_gw1_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_network

  env = module.core.env
  site = module.core.site_ldn
  project = module.core.project
  service = module.core.service_network

  vm_vcpu = var.vm_net_vcpu
  vm_ram = var.vm_net_ram
  vm_subnet = module.core.subnet_ldn_cloud_mgmt
  vm_if = var.vm_if_all_ldn
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

//
// MGMT
//
module "vm_mgmt" {
  source = "github.com/di-starss/vspace307-openlabs-qemu"
  depends_on = [
    consul_key_prefix.config,

    module.img,

    module.vm_controller,
    module.vm_ams_kvm0,
    module.vm_ams_kvm1,
    module.vm_ams_kvm2,
    module.vm_ams_sd_rack_5,
    module.vm_ams_sd_rack_6,
    module.vm_ams_network_gw0,
    module.vm_ams_network_gw1,
    module.vm_ldn_kvm3,
    module.vm_ldn_kvm4,
    module.vm_ldn_kvm5,
  ]

  vm_name = module.core.vm_rg_mgmt_name
  vm_fqdn = module.core.vm_rg_mgmt_fqdn
  vm_hostname = module.core.vm_rg_mgmt_hostname
  vm_ip = module.core.vm_rg_mgmt_ip

  mgmt_user = var.mgmt_user
  mgmt_public_key = local.mgmt_public_key
  mgmt_private_key = local.mgmt_private_key

  openlabs_consul_host = var.openlabs_consul_host
  openlabs_consul_port = var.openlabs_consul_port
  openlabs_consul_schema = var.openlabs_consul_schema

  ansible_playbook = var.ansible_playbook_mgmt

  env = var.env
  site = module.core.site_ams
  project = module.core.project
  service = module.core.service_mgmt

  vm_vcpu = var.vm_mgmt_vcpu
  vm_ram = var.vm_mgmt_ram
  vm_subnet = module.core.subnet_rg_cloud_mgmt
  vm_if = var.vm_if_mgmt_rg
  vm_vdb_size_gb = 1

  img_name = var.img_name

  dns_ns1 = var.dns_ns1

  volume_path_img = var.volume_path_img
  volume_path_pool = var.volume_path_pool
}

//
// POST-DEPLOY
//
resource "null_resource" "controller" {
  depends_on = [module.vm_mgmt]

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl restart nova-scheduler",
      "sudo systemctl restart nova-api"
    ]

    connection {
      type     = "ssh"
      user     = var.mgmt_user
      private_key = local.mgmt_private_key
      host = module.core.vm_rg_controller_ip
    }
  }

}

//
// OUTPUT
//
output "api" { value = "${var.openstack_endpoint_schema}://${module.core.vm_rg_controller_fqdn}:${var.openstack_endpoint_keystone_port}/v3" }
output "mgmt_fqdn" { value = module.core.vm_rg_mgmt_fqdn }
output "mgmt_ip" { value = module.core.vm_rg_mgmt_ip }

output "vm_ams_compute_kvm0_hostname" { value = module.core.vm_ams_compute_kvm0_hostname }
output "vm_ams_compute_kvm1_hostname" { value = module.core.vm_ams_compute_kvm1_hostname }
output "vm_ams_compute_kvm2_hostname" { value = module.core.vm_ams_compute_kvm2_hostname }
output "vm_ldn_compute_kvm3_hostname" { value = module.core.vm_ldn_compute_kvm3_hostname }
output "vm_ldn_compute_kvm4_hostname" { value = module.core.vm_ldn_compute_kvm4_hostname }
output "vm_ldn_compute_kvm5_hostname" { value = module.core.vm_ldn_compute_kvm5_hostname }

output "storage_backend_name_ams_rack_5" { value = module.core.storage_backend_name_ams_rack_5 }
output "storage_backend_name_ams_rack_6" { value = module.core.storage_backend_name_ams_rack_6 }
output "storage_backend_name_ldn_rack_17" { value = module.core.storage_backend_name_ldn_rack_17 }
output "storage_backend_name_ldn_rack_18" { value = module.core.storage_backend_name_ldn_rack_18 }

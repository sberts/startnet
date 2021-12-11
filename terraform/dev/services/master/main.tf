terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

provider "openstack" {
  auth_url    = "http://controller:5000/v3"
  region      = "RegionOne"
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "master secgroup"
  description = "allow all traffic"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_ingress_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = ""
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_compute_instance_v2" "master" {
  name            = var.name
  image_id        = "7b84e04c-a7e2-4349-8bfe-b63f85502cb3"
  flavor_id       = "3828c0b7-df1c-4c78-86bb-d66f3657a3d7"
  key_pair        = var.key_pair
  security_groups = [ openstack_networking_secgroup_v2.secgroup.name ]

  metadata = {
    this = "that"
  }

  network {
    name = var.network
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "provider"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.master.id}"
}

output "floating_ip_addr" {
  value = openstack_networking_floatingip_v2.fip_1.address
}


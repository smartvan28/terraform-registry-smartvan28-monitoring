terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }


  required_version = ">= 0.13"
}

data "yandex_vpc_subnet" "test_subnet" {
  name = "test_subnet"
}

data "yandex_dns_zone" "zone1" {
  name = "my-public-zone"
}

module "smartvan28-network" {
  source  = "smartvan28/smartvan28-network/registry"
  version = "1.0.0"
}


resource "yandex_compute_instance" "test-monitoring" {
  name        = "test-monitoring"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8qps171vp141hl7g9l"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
    nat = true
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }
 
}
  
resource "yandex_dns_recordset" "rs1" {
  zone_id = data.yandex_dns_zone.zone1.id
  name    = "monitoring.docker.smartvan.space."
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.test.network_interface.0.ip_address}"]
}

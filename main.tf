terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }


  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.key1
  cloud_id  = var.cloud_id1
  folder_id = var.folder_id1
  zone      = "ru-central1-a"
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

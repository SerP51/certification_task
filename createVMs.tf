data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "building-vm" {
  name = "building-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_my.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./metadata.yml")}"
  }

}

resource "yandex_compute_instance" "prod-vm" {
  name = "prod-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
    }
  }



  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_my.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./metadata.yml")}"
  }

}

resource "yandex_vpc_network" "network_my" {
  name = "mynet"
}

resource "yandex_vpc_subnet" "subnet_my" {
  name           = "mysubnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_my.id
  v4_cidr_blocks = ["10.178.14.0/24"]
}

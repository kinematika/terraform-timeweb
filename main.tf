terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.4.4"
}

provider "twc" {
  token = "key"
}

  resource "twc_ssh_key" "id_rsa" {
  name = "rhel-klykva-key"
  body = file("~/.ssh/id_rsa.pub")
}

# Select any preset from location = "ru-1", disk_type = "nvme", 1 CPU and 2 Gb RAM with price from 300 RUB up to 400 RUB
data "twc_presets" "example-preset" {
  location = "ru-1"
  disk_type = "ssd"
  cpu = 1
  ram = 1024
  cpu_frequency = 2.8

  price_filter {
    from = 160
    to = 200
  }
}

data "twc_os" "os" {
  name = "ubuntu"
  version = "22.04"
}
resource "twc_server" "example-server" {
  name = "monitor"
  os_id = data.twc_os.os.id

  ssh_keys_ids = [twc_ssh_key.id_rsa.id]
}


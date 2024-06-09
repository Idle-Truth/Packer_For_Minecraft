packer {
  required_plugins {
    openstack = {
      version = "1.1.2"
      source  = "github.com/hashicorp/openstack"
    }
  }
}

source "openstack" "ubuntu" {
  flavor       = "m1.small"
  image_name   = "Minecraft_server_1"
  password     = "plinko"
  region       = "hack-ucf-0"
  source_image = "2bfed951-d17d-4f4d-81fc-8254cc537f63"
  ssh_username = "ubuntu"
  username     = "steve"


}

build {
  sources = ["source.openstack.ubuntu"]

  provisioner "shell" {
    inline = [
        # Add Docker's official GPG key:
        "sudo apt-get update",
        "sudo apt-get install -y ca-certificates curl",
        "sudo install -m 0755 -d /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
        "sudo chmod a+r /etc/apt/keyrings/docker.gpg",

        # Add the repository to Apt sources:
        "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

        # Install Docker packages:
        "sudo apt-get update",
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

        # Verify Docker Engine Install:
        "sudo docker run hello-world",
    ]
  }
}

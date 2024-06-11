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
  region       = "hack-ucf-0"
  source_image = "2bfed951-d17d-4f4d-81fc-8254cc537f63"
  ssh_username = "ubuntu"
  identity_endpoint = "https://api.hackucf.cloud:5000"
  networks = ["165abc1a-baab-4ea2-b096-4c0164830849"]
}

build {
  sources = ["source.openstack.ubuntu"]

  provisioner "shell" {
    inline = [
        # Update the package index
        "sudo apt-get update",

        # Install necessary packages for Docker installation
        "sudo apt-get install -y ca-certificates curl",

        # Create directory for Docker's GPG key
        "sudo install -m 0755 -d /etc/apt/keyrings",

        # Add Docker's official GPG key
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
        "sudo chmod a+r /etc/apt/keyrings/docker.gpg",

        # Add Docker repository to APT sources
        "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

        # Update the package index again after adding Docker repository
        "sudo apt-get update",

        # Install Docker packages
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

        # Verify Docker Engine installation
        "sudo docker run hello-world",
    ]
  }
}

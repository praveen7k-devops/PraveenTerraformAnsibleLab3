#-----compute/main.tf-----
#==========================
provider "aws" {
  region = var.region
}

#Get Linux AMI ID using SSM Parameter endpoint
#===============================================
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
#Create Key Pair for ssh logging into EC2

resource "aws_key_pair" "aws_key" {
  key_name = "webserver"
  public_key = file(var.ssh_key_public)
}

# Template file
#==================
data "template_file" "user-init" {
  template = file("${path.module}/userdata.tpl")
}

#Create and bootstrap webserver
#===============================
resource "aws_instance" "webserver" {
 ami                         = data.aws_ssm_parameter.webserver-ami.value
 instance_type               = "t2.micro"
 associate_public_ip_address = true
 vpc_security_group_ids      = [var.security_group]
 subnet_id                   = var.subnets
 user_data                   = data.template_file.user-init.rendered
  tags = {
    Name = "webserver"
  }

  # this will add the public key in EC2 instance
  key_name = aws_key_pair.aws_key.key_name
  # to establish connection to EC2
  connection {
   type           ="ssh"
   user           ="ec2-user"
   private_key    =file(var.ssh_key_private)
   host           =self.public_ip
   }
  # to copy the YAML from local to EC2
  provisioner "file" {
    source = "install_apache.yaml"
    destination = "install_apache.yaml"
    
  }
  # to execute the script on EC2 resource for installing Apache package
  provisioner "remote-exec"{
    inline = [ 
      "sudo yum update -y && sudo amazon-linux-extras install ansible 2 -y",
      "sleep 60s",
      "ansible-playbook install_apache.yaml"
     ]
  }
  }

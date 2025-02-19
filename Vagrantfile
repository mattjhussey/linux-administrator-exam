# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ensure vagrant version is sufficient
Vagrant.require_version ">= 2.4.1"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  
  
  # # Common provisioning
  # config.vm.provision "shell", inline: "echo Hello"

  # # Common configuration method
  # def configure_web(vm)
  #   vm.box = "apache"
  #   vm.provider "virtualbox" do |vb|
  #     vb.memory = 512
  #     vb.cpus = 2
  #   end
  # end

  # # Define multiple web variants
  # config.vm.define "web1" do |web|
  #   configure_web(web)
  #   # Custom configuration for web1
  #   web.vm.provision "shell", inline: "echo This is web1"
  # end

  # config.vm.define "web2" do |web|
  #   configure_web(web)
  # end

  # config.vm.define "web3" do |web|
  #   configure_web(web)
  # end

  # # Define the database machine
  # config.vm.define "db" do |db|
  #   db.vm.box = "mysql"
  # end
  
  # All Vagrant configuration is done below. The "2" in Vagrant.configure
  # configures the configuration version (we support older styles for
  # backwards compatibility). Please don't change it unless you know what
  # you're doing.
  config.vm.define "ubuntu-ui" do |ubuntu|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    ubuntu.vm.box = "ubuntu/jammy64"

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # config.vm.network "private_network", ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # config.vm.synced_folder "../data", "/vagrant_data"

    # Disable the default share of the current code directory. Doing this
    # provides improved isolation between the vagrant box and your host
    # by making sure your Vagrantfile isn't accessable to the vagrant box.
    # If you use this you may want to enable additional shared subfolders as
    # shown above.
    # config.vm.synced_folder ".", "/vagrant", disabled: true
    #
    # View the documentation for the provider you are using for more
    # information on available options.
    ubuntu.vm.provider "virtualbox" do |vbox|
      vbox.name = "ubuntu-lsa-ui"
    
      # Display the VirtualBox GUI when booting the machine
      vbox.gui = true

      # Enable graphics card. The default does not work
      vbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]

      # Create a DVD device to allow guest additions to be attached
      vbox.customize ["storageattach", :id,
              "--storagectl", "IDE",
              "--port", "0",
              "--device", "1",
              "--type", "dvddrive",
              "--medium", "emptydrive"]

      # Increase memory to improve performance
      vbox.memory = "2048"

      # Enable graphics card. The default does not work
      vbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]

      # Enable bidirectional clipboard
      vbox.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end
    
    # Add user assetman
    ubuntu.vm.provision :shell, inline: <<-SHELL
      useradd -m -s /bin/bash assetman
      echo "assetman:assetman" | chpasswd
    SHELL
  
    # Set keyboard to UK layout persistently
    ubuntu.vm.provision :shell, inline: <<-SHELL
      echo 'XKBMODEL="pc105"' > /etc/default/keyboard
      echo 'XKBLAYOUT="gb"' >> /etc/default/keyboard
      echo 'XKBVARIANT=""' >> /etc/default/keyboard
      echo 'XKBOPTIONS=""' >> /etc/default/keyboard
      dpkg-reconfigure -f noninteractive keyboard-configuration
      setupcon --force
    SHELL
  
    # Update repositories
    ubuntu.vm.provision :shell, inline: "apt-get update -y"
  
    # Update installed packages
    ubuntu.vm.provision :shell, inline: "apt-get upgrade -y"
    
    # Add extra packages
    ubuntu.vm.provision :shell, inline: "apt-get install -y acl tree locate gcc make perl ntpdate"
  
    # Install Virtual Box Guest Additions (Manual for now)
  
    # Allow SSH with password
    ubuntu.vm.provision :shell, inline: "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config"

    # Add desktop environment
    ubuntu.vm.provision :shell, inline: "apt-get install -y ubuntu-desktop"

    # Add UI packages
    ubuntu.vm.provision :shell, inline: "apt-get install -y gnome-software gnome-tweaks synaptic"

    # Install Virtual Box Guest Additions (Manual for now)

    # Restart
    ubuntu.vm.provision :shell, inline: "shutdown -r now"
  end

end

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
  config.vm.define "lfcs-student" do |lfcsstudent|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    lfcsstudent.vm.box = "ubuntu/jammy64"
    lfcsstudent.vm.hostname = "lfcs-student"

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
    # config.vm.network "private_network", ip: "192.168.56.42"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    config.vm.synced_folder "./examiner", "/examiner"

    # Disable the default share of the current code directory. Doing this
    # provides improved isolation between the vagrant box and your host
    # by making sure your Vagrantfile isn't accessable to the vagrant box.
    # If you use this you may want to enable additional shared subfolders as
    # shown above.
    config.vm.synced_folder ".", "/vagrant", disabled: true
    #
    # View the documentation for the provider you are using for more
    # information on available options.
    lfcsstudent.vm.provider "virtualbox" do |vbox|
      vbox.name = "lfcs-student"
    
      # Display the VirtualBox GUI when booting the machine
      vbox.gui = true

      # Disable mouse capturing
      vbox.customize ["setextradata", :id, "GUI/MouseCapturePolicy", "Disabled"]

      # Set 4 cpus
      vbox.cpus = 4

    #   # Enable graphics card. The default does not work
    #   vbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]

    #   # Create a DVD device to allow guest additions to be attached
    #   vbox.customize ["storageattach", :id,
    #           "--storagectl", "IDE",
    #           "--port", "0",
    #           "--device", "1",
    #           "--type", "dvddrive",
    #           "--medium", "emptydrive"]

      # Increase memory to improve performance
      vbox.memory = "4096"

      # Helper method for disk creation and attachment
      def create_and_attach_disk(vbox, filename, port)
        unless File.exist?(filename)
          vbox.customize ['createhd',
             '--filename', filename,
             '--size', 200,
             '--variant', 'Fixed']
        end
        
        vbox.customize ['storageattach', :id,
               '--storagectl', 'SCSI',
               '--port', port,
               '--device', 0,
               '--type', 'hdd',
               '--medium', filename]
      end

      # Add disks for OD/PROC/2
      ['c', 'd', 'e', 'f', 'g'].each_with_index do |disk, index|
        create_and_attach_disk(vbox, 
                 "./od_proc_2_#{disk}.vdi",
                 2 + index)
      end

    #   # Enable graphics card. The default does not work
    #   vbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]

    #   # Enable bidirectional clipboard
    #   vbox.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    end
    
    # Add users
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      useradd -m -s /bin/bash -c "Student" -G sudo student
      echo "student:student" | chpasswd
      # Add student to sudoers with no password
      echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student
      # Add student alias for verification script
      echo "alias runverify='/examiner/verification.sh'" >> /home/student/.bashrc
      chmod +x /examiner/verification.sh

      useradd -m -s /bin/bash -c "Asset Manager" asset-manager
      echo "asset-manager:asset-manager" | chpasswd
    SHELL
  
    # Set keyboard to UK layout persistently
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      echo 'XKBMODEL="pc105"' > /etc/default/keyboard
      echo 'XKBLAYOUT="gb"' >> /etc/default/keyboard
      echo 'XKBVARIANT=""' >> /etc/default/keyboard
      echo 'XKBOPTIONS=""' >> /etc/default/keyboard
      dpkg-reconfigure -f noninteractive keyboard-configuration
      setupcon --force
    SHELL
  
    # Update repositories
    lfcsstudent.vm.provision :shell, inline: "apt-get update -y"
  
    # Update installed packages
    # lfcsstudent.vm.provision :shell, inline: "apt-get upgrade -y"

    # Add extra packages
    lfcsstudent.vm.provision :shell, inline: "apt install sshpass bzip2 build-essential virtinst libvirt-daemon-system -y"
    
    # # Add extra packages
    # ubuntu.vm.provision :shell, inline: "apt-get install -y acl tree locate gcc make perl ntpdate"
  
    # # Install Virtual Box Guest Additions (Manual for now)
  
    # # Allow SSH with password
    # ubuntu.vm.provision :shell, inline: "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config"

    # # Add desktop environment
    # ubuntu.vm.provision :shell, inline: "apt-get install -y ubuntu-desktop"

    # # Add UI packages
    # ubuntu.vm.provision :shell, inline: "apt-get install -y gnome-software gnome-tweaks synaptic"

    # # Install Virtual Box Guest Additions (Manual for now)

    # # Restart
    # ubuntu.vm.provision :shell, inline: "shutdown -r now"

    lfcsstudent.vm.provision "shell", inline: <<-SHELL
      echo "192.168.56.10 web-srv1" >> /etc/hosts
      echo "192.168.56.11 web-srv2" >> /etc/hosts
      echo "192.168.56.12 web-srv3" >> /etc/hosts
      echo "192.168.56.13 app-dev1" >> /etc/hosts
    SHELL

    # Configure SSH known hosts for all servers
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      mkdir -p /home/student/.ssh

      cp /examiner/known_hosts /home/student/.ssh/known_hosts
      chown student:student /home/student/.ssh/known_hosts
      chmod 644 /home/student/.ssh/known_hosts

      for ip in 192.168.56.{10..13}; do
        ssh-keyscan -H $ip >> /home/student/.ssh/known_hosts 2>/dev/null
      done
      echo "StrictHostKeyChecking no" > /home/student/.ssh/config
      chown -R student:student /home/student/.ssh
      chmod 700 /home/student/.ssh
      chmod 600 /home/student/.ssh/config
    SHELL

    # Add disk mounting
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      mkfs.ext4 /dev/sdd
      mkdir -p /mnt/odproc2_1
      echo '/dev/sdd /mnt/odproc2_1 ext4 defaults 0 0' >> /etc/fstab
      mount /mnt/odproc2_1

      mkfs.ext4 /dev/sde
      mkdir -p /mnt/odproc2_2
      echo '/dev/sde /mnt/odproc2_2 ext4 defaults 0 0' >> /etc/fstab
      mount /mnt/odproc2_2

      mkfs.ext4 /dev/sdf
      mkdir -p /mnt/odproc2_3
      echo '/dev/sdf /mnt/odproc2_3 ext4 defaults 0 0' >> /etc/fstab
      mount /mnt/odproc2_3

      mkfs.ext4 /dev/sdg
      mkdir -p /mnt/odproc2_4
      echo '/dev/sdg /mnt/odproc2_4 ext4 defaults 0 0' >> /etc/fstab
      mount /mnt/odproc2_4
    SHELL

    # Set up OD/PROC/2
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      mkdir /mnt/odproc2_1/.trash
      for i in {1..999}; do mkdir -p /mnt/odproc2_1/.trash/$i; touch /mnt/odproc2_1/.trash/$i/file; done
      mkdir /mnt/odproc2_2/.trash
      # Create 999 folders with empty files, with one folder containing a 100MB file
      for i in {1..999}; do
        mkdir -p /mnt/odproc2_2/.trash/$i
        if [ $i -eq 500 ]; then
          dd if=/dev/zero of=/mnt/odproc2_2/.trash/$i/file bs=1M count=160
        else
          touch /mnt/odproc2_2/.trash/$i/file
        fi
      done

      # Create memory-consuming processes
      cat > /mnt/odproc2_3/dark-matter-1 << 'EOF'
#!/bin/bash
while true; do
  printf -v x %10000000s
  sleep 10
  unset x
done
EOF

  cat > /mnt/odproc2_4/dark-matter-2 << 'EOF'
#!/bin/bash
while true; do
  printf -v x %100000000s
  sleep 10
  unset x
done
EOF

      chmod +x /mnt/odproc2_3/dark-matter-1
      chmod +x /mnt/odproc2_4/dark-matter-2

      cat > /etc/systemd/system/dark-matter-1.service << EOF
[Unit]
Description=10MB Memory Consumer
After=network.target

[Service]
Type=simple
ExecStart=/mnt/odproc2_3/dark-matter-1
Restart=on-reboot

[Install]
WantedBy=multi-user.target
EOF

      cat > /etc/systemd/system/dark-matter-2.service << EOF
[Unit]
Description=50MB Memory Consumer
After=network.target

[Service]
Type=simple
ExecStart=/mnt/odproc2_4/dark-matter-2
Restart=on-reboot

[Install]
WantedBy=multi-user.target
EOF

      systemctl enable dark-matter-1.service dark-matter-2.service
      systemctl start dark-matter-1.service dark-matter-2.service
    SHELL

    # Set up OD/PROC/3
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      apt install -y nginx
      systemctl enable nginx
      systemctl start nginx
    SHELL

    # Set up OD/SCHED/2
    lfcsstudent.vm.provision :shell, inline: <<-SHELL
      cat > /home/asset-manager/clean.sh << 'EOF'
echo "Cleaning up..."
EOF
      cat >> /etc/crontab << EOF
30 20 * * * root /home/asset-manager/clean.sh
EOF
    SHELL
  end

  config.vm.define "web-srv1" do |websrv|
    websrv.vm.box = "ubuntu/jammy64"
    websrv.vm.hostname = "web-srv1"
    
    websrv.vm.provider "virtualbox" do |vbox|
      vbox.name = "web-srv1"
      vbox.memory = "2048"
    end

    # Create a private network for SSH access
    websrv.vm.network "private_network", ip: "192.168.56.10"

    # Basic provisioning
    websrv.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      # apt-get upgrade -y
      # Enable password authentication for SSH
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      systemctl restart sshd
      # Create user with sudo access
      useradd -m -s /bin/bash -G sudo student
      echo "student:student" | chpasswd
      echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student

      useradd -m -s /bin/bash -c "Examiner" -G sudo examiner
      echo "examiner:examiner" | chpasswd 
      echo "examiner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/examiner

      # Create null process script
      cat > /usr/local/bin/collector1 << 'EOF'
#!/bin/bash
while true; do
    sleep 5
done
EOF

      # Create kill process script
      cat > /usr/local/bin/collector2 << 'EOF'
#!/bin/bash
while true; do
    kill -0 1
    sleep 5
done
EOF
      # Create null process script
      cat > /usr/local/bin/collector3 << 'EOF'
#!/bin/bash
while true; do
    sleep 5
done
EOF

      # Make scripts executable
      chmod +x /usr/local/bin/collector1
      chmod +x /usr/local/bin/collector2
      chmod +x /usr/local/bin/collector3

      # Create systemd service files
      cat > /etc/systemd/system/collector1.service << EOF
[Unit]
Description=Collector Process 1
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/collector1
Restart=on-reboot
RestartSec=0
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

      cat > /etc/systemd/system/collector2.service << EOF
[Unit]
Description=Collector Process 2
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/collector2
Restart=on-reboot
RestartSec=0
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

      cat > /etc/systemd/system/collector3.service << EOF
[Unit]
Description=Collector Process 3
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/collector3
Restart=on-reboot
RestartSec=0
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

      # Enable and start the services
      systemctl enable collector1.service
      systemctl enable collector2.service
      systemctl enable collector3.service
      systemctl start collector1.service
      systemctl start collector2.service
      systemctl start collector3.service
    SHELL

    # Set up OD/VIRT/1
    websrv.vm.provision :shell, inline: <<-SHELL
      curl -o /var/lib/libvirt/images/ubuntu.img https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
    SHELL
  end

  config.vm.define "web-srv2" do |websrv2|
    websrv2.vm.box = "generic/centos9s"
    websrv2.vm.hostname = "web-srv2"
    
    websrv2.vm.provider "virtualbox" do |vbox|
      vbox.name = "web-srv2"
      vbox.memory = "1024"
    end

    websrv2.vm.network "private_network", ip: "192.168.56.11"

    websrv2.vm.provision "shell", inline: <<-SHELL
      dnf update -y
      # Enable password authentication for SSH
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      systemctl restart sshd
      useradd -m -s /bin/bash student
      echo "student:student" | chpasswd
      echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student

      useradd -m -s /bin/bash -c "Examiner" examiner
      echo "examiner:examiner" | chpasswd 
      echo "examiner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/examiner
    SHELL

    # Set up OD/PROC/3
    websrv2.vm.provision :shell, inline: <<-SHELL
      dnf install -y httpd
      systemctl enable httpd
      systemctl start httpd
    SHELL
  end

  config.vm.define "web-srv3" do |websrv3|
    websrv3.vm.box = "ubuntu/jammy64"
    websrv3.vm.hostname = "web-srv3"
    
    websrv3.vm.provider "virtualbox" do |vbox|
      vbox.name = "web-srv3"
      vbox.memory = "1024"
    end

    websrv3.vm.network "private_network", ip: "192.168.56.12"

    websrv3.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      systemctl restart sshd
      
      useradd -m -s /bin/bash -G sudo student
      echo "student:student" | chpasswd
      echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student

      useradd -m -s /bin/bash -c "Examiner" -G sudo examiner
      echo "examiner:examiner" | chpasswd 
      echo "examiner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/examiner

      apt install -y nginx
    SHELL
  end

  config.vm.define "app-dev1" do |appdev1|
    # app-dev1 is a new development server but has nothing installed
    appdev1.vm.box = "ubuntu/jammy64"
    appdev1.vm.hostname = "app-dev1"
    
    appdev1.vm.provider "virtualbox" do |vbox|
      vbox.name = "app-dev1"
      vbox.memory = "1024"
    end

    appdev1.vm.network "private_network", ip: "192.168.56.13"

    appdev1.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      systemctl restart sshd
      
      useradd -m -s /bin/bash -G sudo student
      echo "student:student" | chpasswd
      echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student

      useradd -m -s /bin/bash -c "Examiner" -G sudo examiner
      echo "examiner:examiner" | chpasswd 
      echo "examiner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/examiner
    SHELL
  end

end

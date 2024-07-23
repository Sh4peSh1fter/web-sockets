# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
REQUIRED_PLUGINS = ["vagrant-vbguest", "vagrant-disksize"]
CONF_VERSION = "2"
BOX_NAME = "generic/rhel8"
VM_NAME = "web-sockets-vm"
USERNAME = "vagrant"
PASSWORD = "vagrant"
CPU = "2"
MEMORY = "4096"
HOST_SHARED_FOLDER_PATH = "."				    # SHARED_FOLDER_PATH_SRC
WORKSTATION_SHARED_FOLDER_PATH = "/vagrant"		# SHARED_FOLDER_PATH_DST

Vagrant.require_version ">= 2.0.0"

# Plugin Installation
plugins_to_install = REQUIRED_PLUGINS.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

# Configuration
Vagrant.configure(CONF_VERSION) do |config|
  # VM configuration
  config.vm.define VM_NAME do |ws|
    ws.vm.box = BOX_NAME
    ws.vm.hostname = VM_NAME
    ws.vm.boot_timeout = 300
    #ws.ssh.username = USERNAME
    #ws.ssh.password = PASSWORD
    ws.vm.synced_folder HOST_SHARED_FOLDER_PATH, WORKSTATION_SHARED_FOLDER_PATH, disabled: true #, create: true  
    ## Disable automatic box update checking
    ws.vm.box_check_update = false
    
    # Network
    ## Grab the name of the default interface
    #$default_network_interface = `ip route | awk '/^default/ {printf "%s", $5; exit 0}'`
    #config.vm.network "public_network", bridge: "#$default_network_interface"

    # VirtualBox provider configuration
    ws.vm.provider "virtualbox" do |vb|
      vb.name = VM_NAME
      vb.cpus = CPU
      vb.memory = MEMORY
      vb.gui = true
      vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      # graphics controller - set for linux vm
      vb.customize ['modifyvm', :id, '--clipboard-mode', 'bidirectional']  # clipboard settings - enable between both host and vm
      # for more customization options to play with in virtualbox, read https://www.virtualbox.org/manual/ch08.html
    end

    # Plugins
    ws.vagrant.plugins = ["vagrant-vbguest"]#, "vagrant-env"]
    if Vagrant.has_plugin?("vagrant-vbguest")
      # ws.vbguest.installer_options = { running_kernel_modules: ["vboxguest"] }
      ws.vbguest.auto_update = true
      ws.vbguest.installer_options = { allow_kernel_upgrade: true }
    end

    # Provisioning Steps
    ## initial provision
    ws.vm.provision "initial-provision", type: "shell" do |shell|
      shell.path = "provision/initial-provision-ubuntu.sh"
    end

    # ## setup docker
    # ws.vm.provision "setup-docker", type: "ansible" do |ansible|
    #   ansible.playbook = "provision/setup-docker-pb.yaml"
    # end

    ## initial restart
    ws.vm.provision "initial-restart", type: "shell" do |shell|
      shell.inline = "shutdown -r now"
    end

    # Welcome Message
    ws.vm.post_up_message = <<-TEXT
  ##############################################################

      This is a RHEL-08 VM for testing web sockets apps.		
    
    Have fun :)
            
  ##############################################################
    TEXT
  
    # Destroy Message
    ws.trigger.before :destroy do |trigger|
      trigger.name = "before destroy trigger"
      trigger.warn = "deleteing the VM"
      # trigger.run_remote = {inline: unregister_script}
      # trigger.on_error = :continue
    end
  end
end

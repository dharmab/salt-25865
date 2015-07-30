# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    # Defaults
    config.vm.box = "chef/centos-6.6"
    config.vm.provision "shell", inline: "cp /vagrant/conf/hosts /etc/hosts"

    # Salt minions
    # Array where each element is a hash containing the following:
    # 
    # hostname: Hostname to assign to the VM.
    # ip: Private IP address to assign to the VM. This should also be set in
    # conf/hosts.
    # forwarded_ports: Array of hashes. Each has should contain a "guest"
    # element which is the port to forward from the guest and a "host" element
    # which us the port to forward to the host
    #
    # Salt private and public keys should be pre-generated and placed in the 
    # keys/ directory. Each .pub and .pem file should have the same filename
    # as the hostname of the VM. You can generate keys with
    # salt-key --gen-keys=<minion name>
    minions = [
        {
            hostname: "development",
            ip: "192.168.10.11",
            forwarded_ports: []
        },
        {
            hostname: "testing",
            ip: "192.168.10.12",
            forwarded_ports: []
        },
        {
            hostname: "production",
            ip: "192.168.10.13",
            forwarded_ports: []
        }
    ]

    minions.each do |minion|
        hostname = minion[:hostname]
        config.vm.define hostname, autostart: true do |minion_vm|
            minion_vm.vm.hostname = hostname
            minion_vm.vm.network "private_network", ip: minion[:ip] 
            minion[:forwarded_ports].each do |ports| 
                minion_vm.vm.network "forwarded_port", guest: ports[:guest], host: ports[:host]
            end
            minion_vm.vm.provision :salt do |salt|
                salt.minion_key = "keys/#{hostname}.pem"
                salt.minion_pub = "keys/#{hostname}.pub"
            end
        end
    end

    # Salt master
    config.vm.define "salt", primary: true do |master|
        master.vm.provision "shell", path: "provision.sh"
        master.vm.network "private_network", ip: "192.168.10.10"
        master.vm.provision :salt do |salt|
            salt.install_master = true
            salt.master_config = "conf/master"
            salt.seed_master = Hash[minions.collect { |minion| [minion[:hostname], "keys/#{minion[:hostname]}.pub"] }]
        end
    end
end

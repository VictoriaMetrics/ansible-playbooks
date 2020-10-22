Vagrant.configure("2") do |config|
  config.vm.base_mac = nil
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vbguest.auto_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
    vb.cpus = 1
    vb.linked_clone = true
  end

  N = 3
  (1..N).each do |machine_id|
    config.vm.define "load-balancer-1" do |n|
      n.vm.hostname = "load-balancer-1"
      n.vm.network "private_network", ip: "192.168.77.1"
      n.vm.box = "debian/buster64"
    end

    config.vm.define "victoria-#{machine_id}" do |n|
      n.vm.hostname = "victoria-#{machine_id}"
      n.vm.network "private_network", ip: "192.168.77.#{20+machine_id}"
      n.vm.box = "debian/buster64"

      if machine_id == N
        n.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.playbook = "monitoring.yml.example"
          ansible.groups = {
            "victoria_cluster" => [ "victoria-[1:#{N}]" ],
            "victoria_cluster:vars" => { "if_name" => "eth1", "vminsert_replication_factor" => 2 },
            "load_balancer" => [ "load-balancer-1" ],
            "load_balancer:vars" => { "if_name" => "eth1" }
          }
          ansible.raw_arguments = [ "-D"]
        end
      end
    end
  end
end

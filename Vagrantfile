# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box       = "canonical-ubuntu-12.04"
  config.vm.box_url   = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  config.omnibus.chef_version = :latest
  
  config.vm.hostname = "lifeguard-cookbook-test"
  
  config.berkshelf.enabled = true
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm",:id,"--cpus",1]
    vb.customize ["modifyvm",:id,"--memory",1*512]
  end
  
  config.vm.provision :chef_solo do |chef|    
    chef.json = {
      nodejs: {
        install_method: "package"
      }
    }
    
    chef.run_list = [
      "recipe[lifeguard]",
      "recipe[lifeguard::test_provider]"
    ]
  end
end

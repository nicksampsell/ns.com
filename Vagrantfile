# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu1204lts"
	config.vm.box_url = "http://goo.gl/8kWkm"
	config.vm.network :private_network, ip: "192.168.33.10"
	config.vm.synced_folder "./app", "/home/vagrant/public_html/dev.nicksampsell.com"
	config.vm.synced_folder "./puppet", "/home/vagrant/.puppet/"

	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "puppet"
		puppet.manifest_file  = "site.pp"
		puppet.options = "--verbose --debug"
	end
end

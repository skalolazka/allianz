# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

seeds = '192.168.10.10,192.168.20.10'

cassandra_cluster = [
  {
    :name => 'dc1-node1', :ip => '192.168.10.10', :cass_name => 'cass-dc1-n1', :dc => 'Datacenter1', :rack => 'R1'
  },
  {
    :name => 'dc1-node2', :ip => "192.168.10.20", :cass_name => 'cass-dc1-n2', :dc => 'Datacenter1', :rack => 'R1'
  },
  {
    :name => 'dc1-node3', :ip => "192.168.10.30", :cass_name => 'cass-dc1-n3', :dc => 'Datacenter1', :rack => 'R1'
  },
  {
    :name => 'dc2-node1', :ip => "192.168.20.10", :cass_name => 'cass-dc2-n1', :dc => 'Datacenter2', :rack => 'R1'
  },
  {
    :name => 'dc2-node2', :ip => "192.168.20.20", :cass_name => 'cass-dc2-n2', :dc => 'Datacenter2', :rack => 'R1'
  }
]

Vagrant.configure("2") do |config|

  config.vm.box = 'ubuntu/trusty64'

  cassandra_cluster.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.network "private_network", ip: opts[:ip]
      config.vm.hostname = opts[:name]
      config.vm.provision "docker" do |d|
        d.build_image "/vagrant/install",
          args: "-t multidc-cassandra "
        d.run opts[:cass_name],
          args: "--name " + opts[:cass_name] + " --net=host multidc-cassandra ./start_cassandra.pl " + seeds + " " + opts[:ip] + " " + opts[:dc] + " " + opts[:rack]
      end
      config.vm.provider "virtualbox" do |v|
        v.memory = 1024
      end
    end
  end

end

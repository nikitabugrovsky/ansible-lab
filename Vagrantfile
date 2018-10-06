# -*- mode: ruby -*-
# vi: set ft=ruby :

# provisioners map
# 0 - hosts
# 1 - shell

require_relative 'lib/vagrant'

work_dir = File.dirname(File.expand_path(__FILE__))
opts = vagrant_config(work_dir)
check_plugins(opts['plugins'])

Vagrant.configure("2") do |config|

  config.cache.auto_detect = opts['cache']['auto_detect']

  config.vm.provider :virtualbox do |pr|
    pr.memory = opts['provider']['virtualbox']['vm']['mem']
    pr.cpus = opts['provider']['virtualbox']['vm']['cpu']
  end

  opts['provider']['virtualbox']['nodes'].each do |node|
    config.vm.define node['name'] do |cfg|
      cfg.vm.box = opts['provider']['virtualbox']['vm']['box']
      cfg.vm.hostname = node['hostname']
      cfg.vm.network opts['provider']['virtualbox']['vm']['net'].to_sym, ip: node['ip']
      cfg.vm.provision opts['provisioner'][0]['type'].to_sym, :sync_hosts => opts['provisioner'][0]['sync_hosts']
      if node['name'] == 'control-node'
        cfg.vm.provision opts['provisioner'][1]['type'].to_sym, :path  => "#{work_dir}/provisioning/control_node.sh"
      end
    end
  end

end


# -*- mode: ruby -*-
# vi: set ft=ruby :

# provisioners map
# 0 - hosts
# 1 - shell

require_relative 'lib/vagrant'

work_dir = File.dirname(File.expand_path(__FILE__))
ssh_keys_dir = "#{work_dir}/ssh"
shell_provisioning_dir = "#{work_dir}/provisioning/shell"
ansible_provisioning_dir = "#{work_dir}/provisioning/ansible"
vagrant_guest_home = "/home/vagrant"
destination_dir = "#{vagrant_guest_home}/.ssh"
opts = vagrant_config(work_dir)
check_plugins(opts['plugins'])
generate_ssh_keys(ssh_keys_dir, 'id_rsa')
pub_key = File.read(File.join(ssh_keys_dir, 'id_rsa.pub'))
nodes_array = opts['provider']['virtualbox']['nodes']
worker_nodes = extract_worker_nodes(nodes_array)

Vagrant.configure("2") do |config|

  config.cache.auto_detect = opts['cache']['auto_detect']
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |pr|
    pr.memory = opts['provider']['virtualbox']['vm']['mem']
    pr.cpus = opts['provider']['virtualbox']['vm']['cpu']
  end

  nodes_array.each do |node|
    config.vm.define node['name'] do |cfg|
      cfg.vm.box = opts['provider']['virtualbox']['vm']['box']
      cfg.vm.hostname = node['hostname']
      cfg.vm.network opts['provider']['virtualbox']['vm']['net'].to_sym, ip: node['ip']
      cfg.vm.provision opts['provisioner'][0]['type'].to_sym, sync_hosts: opts['provisioner'][0]['sync_hosts']
      if node['name'] == 'control-node'
        cfg.vm.provision opts['provisioner'][1]['type'].to_sym do |s| 
          s.path = "#{shell_provisioning_dir}/control_node.sh"
          s.args = worker_nodes
        end
        cfg.vm.provision opts['provisioner'][2]['type'].to_sym, source: ssh_keys_dir, destination: destination_dir
      else
        cfg.vm.provision opts['provisioner'][1]['type'].to_sym do |s|
          s.path = "#{shell_provisioning_dir}/key_distribution.sh"
          s.args = [ pub_key ]
        end
      end
    end
  end
end

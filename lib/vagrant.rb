# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods to start 
# vagrant test env

require 'yaml'

def check_providers(allowed_providers)
  allowed_providers.each do |ap|
    if Vagrant.has_plugin?(ap)
      puts "Provider #{ap} has been found. Proceeding..."
      provider = :libvirt
      return provider
    end
  end
  puts 'Provider plugins have not been found.'
  puts 'Falling back to virtualbox provider.'
  provider = :virtualbox
  return provider
end

def check_plugins(required_plugins)
  plugins_to_install = []
  required_plugins.each do |plugin_name|
    unless Vagrant.has_plugin?(plugin_name)
      plugins_to_install.append(plugin_name)
    end
  end
  unless plugins_to_install.empty?
    puts '---------- WARNING ----------'
    puts 'Please install vagrant plugins'
    puts 'with the following command:'
    puts "# vagrant plugin install #{plugins_to_install.join(" ")}"
    puts '------------ END ------------'
    exit 0
  end
end

def vagrant_config(work_dir)
  @options = {}
  conf_files = Dir.glob("#{work_dir}/conf/*.yaml")
  conf_files.each do |f|
    # https://github.com/ruby/psych/issues/533
    if Psych::VERSION > '4.0'
      @options.merge!(YAML.load_file(f, aliases: true))
    else
      @options.merge!(YAML.load_file(f))
    end
  end
  @options
end

def generate_ssh_keys(ssh_keys_dir, key_name)
  unless File.file?(File.join(ssh_keys_dir, key_name))
    system("ssh-keygen -f #{File.join(ssh_keys_dir, key_name)} -q -N '' -t rsa -C 'vagrant@control-node'")
    FileUtils.chmod(0600, File.join(ssh_keys_dir, "#{key_name}.pub"))
    FileUtils.chmod(0600, File.join(ssh_keys_dir, "#{key_name}"))
  end
end

def prepare_ssh_config(ssh_key_dir)
  FileUtils.chmod(0600, File.join(ssh_key_dir, 'config'))
end

def extract_worker_nodes(nodes_array)
  workers = []
  nodes_array.each do |node|
    workers << node['name'] if node['name'] =~ /(\w+)-\d/
  end
  workers
end

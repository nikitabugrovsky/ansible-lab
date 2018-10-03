# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods to start 
# vagrant test env

require 'yaml'

def check_plugins(required_plugins)
  required_plugins.each do |plugin_name|
    unless Vagrant.has_plugin?(plugin_name)
      puts '---------- WARNING ----------'
      puts 'Please install vagrant plugin'
      puts 'with the following command:'
      puts "# vagrant plugin install #{plugin_name}"
      puts '------------ END ------------'
      exit 0
    end
  end
end

def vagrant_config(work_dir)
  @options = {}
  conf_files = Dir.glob("#{work_dir}/conf/*.yaml")
  conf_files.each do |f|
    @options.merge!(YAML.load_file(f))
  end
  @options
end
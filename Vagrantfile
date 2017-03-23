# -*- mode: ruby -*-
# vi: ft=ruby sw=0 ts=2 et fdm=marker

# Env var enabled {{{1
################################################################

def envvar_enabled(var)
  ! ENV[var].nil? and ['true', 'yes'].include? ENV[var].downcase
end

# Message {{{1
################################################################

def message(config, msg)
  config.vm.provision "shell", privileged: false, inline: "echo \"---------------- W4M VM ---------------- #{msg}\""
end

# MAIN {{{1
################################################################

Vagrant.configure(2) do |config|

  # Box
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "w4m"

  # Network
  config.vm.network :forwarded_port, guest: 8080, host: 8080

  # Set virtual memory
  message(config, envvar_enabled('ENABLE_GUI') ? 'GUI ENABLED' : 'GUI DISABLED')
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.gui = envvar_enabled('ENABLE_GUI')
  end
 
  # Set AZERTY keyboard layout
  if envvar_enabled('ENABLE_AZERTY')
    message(config, 'SETTING AZERTY KEYBOARD')
    config.vm.provision :shell, privileged: true, path: "vagrant-azerty.sh"
  else
    message(config, 'SETTING QWERTY KEYBOARD')
  end
 
  # Install Galaxy
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "galaxyserver.yml" 
  end

  config.vm.provision "file", source: "w4m-config/config/tool_conf.xml", destination: "galaxy/config/tool_conf.xml"
  config.vm.provision "file", source: "w4m-config/config/tool_sheds_conf.xml", destination: "galaxy/config/tool_sheds_conf.xml"
  config.vm.provision "file", source: "w4m-config/config/dependency_resolvers_conf.xml", destination: "galaxy/config/dependency_resolvers_conf.xml"
  config.vm.provision "file", source: "w4m-config/static/welcome.html", destination: "galaxy/static/welcome.html"
  config.vm.provision "file", source: "w4m-config/static/W4M", destination: "galaxy/static/W4M"

  # Install Galaxy tools
  if ENV['TOOLS'].nil?
    message(config, "NO TOOLS INSTALLATION")
  else
    
    # Set branch
    if ENV['BRANCH'].nil?
      branch=develop
    else
      branch=ENV['BRANCH']
    end
    
    # Set tools
    tools = []
    if ENV['TOOLS'] == 'all'
      Dir.glob('./vagrant-install-tool-*.sh') { |file| tools.push(file[/^.*vagrant-install-tool-(.*)\.sh$/, 1]) }
    else
      tools=ENV['TOOLS'].split(/ */)
    end
    
    # Install requirements
    config.vm.provision :shell, privileged: false, path: "vagrant-tool-installation-requirements.sh", run: "always"
    
    # Loop on all tools
    tools.each do |tool|
    
      message(config, "INSTALLING TOOL #{tool} FROM BRANCH #{branch}")
      config.vm.provision :shell, privileged: false, path: "vagrant-install-tool-#{tool}.sh", args:branch, run: "always"
    end
  end

  # Start galaxy in daemon mode
  message(config, "START GALAXY IN DAEMON MODE")
  config.vm.provision :shell, privileged: false, path: "vagrant-run-galaxy.sh", args:"start", run: "always"

end

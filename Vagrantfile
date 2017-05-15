# vim: set ft=ruby:

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 443, host: 4443
  config.vm.network "forwarded_port", guest: 80,  host: 8080

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |box|
    box.memory = 1024
  end

  config.trigger.after [:provision, :up, :reload] do
    system <<-EOC
      echo "
        rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080
        rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 4443
      " | sudo pfctl -ef - > /dev/null 2>&1;
      echo "==> Fowarding Ports: 80 -> 8080, 443 -> 4443"
    EOC
  end

  config.trigger.after [:halt, :destroy] do
    system <<-EOC
      sudo pfctl -df /etc/pf.conf > /dev/null 2>&1;
      echo "==> Removing Port Forwarding"
    EOC
  end
end

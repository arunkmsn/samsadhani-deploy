# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hashicorp/precise64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./data", "/home/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    # Install Dependencies
    cd /home/vagrant
    sudo rm -rf /var/lib/apt/lists/*
    sudo apt-get update --fix-missing -o Acquire::CompressionTypes::Order::=gz
    INSTALL_PKGS="build-essential apache2 bison flex graphviz g++ openjdk-8-jdk lttoolbox make perl python xsltproc git perl libcgi-pm-perl opam"
    for i in $INSTALL_PKGS; do
      sudo apt-get install -y $i
    done

    # Install right ocaml version
        # environment setup
    opam init
    eval `opam config env`
        # install given version of the compiler
    opam switch 4.07.0
    eval `opam config env`
        # check you got what you want
    which ocaml
    ocaml --version
    opam install -y camlp4

    # Configure web service
    cd /etc/apache2/mods-enabled
    sudo ln -s ../mods-available/cgi.load
    sudo service apache2 restart
    cd /home/vagrant

    # Install software
    rm -rf SKT scl
    mkdir /home/vagrant/SKT
    cd SKT
    git clone https://gitlab.inria.fr/huet/Heritage_Platform.git
    git clone https://gitlab.inria.fr/huet/Heritage_Resources.git
    git clone https://gitlab.inria.fr/huet/Zen.git
    cd Heritage_Platform

    cat >SETUP/config <<HERE
    ZENDIR='/home/vagrant/SKT/Zen/ML'
    PLATFORM='Station'
    TRANSLIT='WX'
    LEXICON='SH'
    DISPLAY='deva'
    SERVERHOST='127.0.0.1'
    SERVERPUBLICDIR='/var/www/html/SKT/# amba'
    SKTDIRURL='/SKT/# amba'
    SKTRESOURCES='/home/vagrant/SKT/Heritage_Resources/'
    CGIBINURL='/cgi-bin/SKT/# amba'
    CGIDIR='/usr/lib/cgi-bin/SKT/# amba'
    CGIEXT='# amba'
    MOUSEACTION='CLICK'
    CAPTION='Amba's mirror site'
HERE

    ./configure && make -k && sudo make install
    cd /home/vagrant

    git clone http://scl.samsaadhanii.in:3000/amba/scl.git
    cd scl

    cat >spec.txt <<HERE2
    #Path for ZEN Library
    ZENDIR=/home/vagrant/SKT/Zen/ML
    #Path for installation of all packages.
    SCLINSTALLDIR=/home/vagrant/scl

    #Paths for enabling web services
    HTDOCSDIR=/var/www/html

    CGIDIR=/usr/lib/cgi-bin

    APACHE_USER_GROUP=www-data:www-data

    #Path for JAVA
    JAVAPATH=/usr/bin/javac

    #Path of lt-proc
    LTPROCBIN=/usr/bin/lt-proc

    #Paths for webdot.pl
    GraphvizDot=/usr/bin/dot

    #Heritage installation path (for interface)
    HERITAGE_CGIURL=/cgi-bin/SKT/sktgraph

    #Path for temporary files
    TFPATH=/tmp/SKT_TEMP

    #Version SERVER/STANDALONE
    VERSION=SERVER
HERE2

    ./configure && make -k && sudo make install
  SHELL
end

#!/bin/bash

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

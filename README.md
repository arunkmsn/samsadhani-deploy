# samsadhani-deploy
[Samsaadhani](http://scl.samsaadhanii.in:3000/amba/scl) is a project by University of Hyderabad which consists of a family of tools related to parsing, analysing, translating and processing sanskrit. The tool involves components of diverse nature. It ranges from ocaml libraries o a CGI web app. OCaml components from indology departments in INRIA, France which has the core automata (on which part of the tool is based), involves compilation with makefiles and appropriate dependent libraries. Web interface with perl backend depends on proper server config.

It can be a daunting task for a traditional sanskrit scholar to put all this components together and run them so that he can get on with his work. This project aims to do just that with the help of a virtual machine on which a script handles all dependencies required to run it.

# Prerequisites

* [Vagrant](https://www.vagrantup.com/) Environment manager using pre-built VMs (also known as Box)
* [Virtualbox](https://www.virtualbox.org/) Open source Virtual Machine software available for all platforms.

## On Ubuntu
Simply install by doing `sudo apt install vagrant virtualbox`

## On Windows and Mac
Download the installation bundle for Vagrant from [here](https://www.vagrantup.com/downloads.html) and for Virtualbox [here](https://www.virtualbox.org/wiki/Downloads)


# Usage
* Checkout this repo using `git clone https://github.com/arunkmsn/samsadhani-deploy`
* `cd` into `samsadhani-deploy`
* Execute `./init.sh` (This may take some time if it's a fresh install)
* Do `vagrant up`. This will boot the VM and also start compiling the software and install them
* Finally do `vagrant ssh` to login to your machine if you want to use command line software
* You can access the web interface at http://192.168.33.10/scl/ once `vagrant up` is successful.

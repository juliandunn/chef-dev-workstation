# chef-dev-workstation cookbook
This cookbook contains recipes to set up a cookbook development environment on Windows or *nix machines.  Many Chef users have requested an easy way to set up their system with all the basics required to get started with cookbook authoring and testing, and that is the purpose of this cookbook. Feature requests are most welcome!

**Linux recipe:**
* Vim with Syntastic and Rubocop checker
* Nano with Ruby highlighting
* Emacs
* Berkshelf
* ChefSpec
* Foodcritic
* Rubocop
* Test Kitchen
* knife-essentials, knife-windows, knife-spork, knife-ec2 and knife-vsphere

**Windows recipe:**
* Downloads and installs the Sublime Text editor (Free trial, will nag you to purchase every 5 saves).
* Downloads and installs the Notepad++ text editor.
* Sets up the following useful powershell aliases:
  + n (starts up notepad++)
  + s (starts up Sublime Text)
  + k (runs knife)
  + chef (runs chef-client)
* Sets environment variable for Sublime Text, so you can run "knife node edit", etc.
* Enables QuickEdit mode for CMD and Powershell
* Downloads and installs Git
* Berkshelf
* ChefSpec
* Foodcritic
* Rubocop
* Test Kitchen
* knife-essentials, knife-windows, knife-spork, knife-ec2 and knife-vsphere

# Requirements
This cookbook has been tested on CentOS 6.4 and Windows Server 2008r2. It will probably work on other platforms as well but we make no guarantees! You'll need to install Chef on your workstation before you can use this cookbook.  You can get Chef here:  http://www.getchef.com

# Usage
**Linux:**

If you're using Vagrant and Virtualbox, you can simply clone the repo and run "vagrant up".  That will spin up a CentOS 6.4 virtual machine and configure everything for you.  Or if you want to run it on your own VM or workstation, read on...

The setup recipe uses the built-in Omnibus Ruby that ships with Chef, so you don't have to mess around with RubyGems, Bundler or other dependencies. Usage is fairly simple, just run the default recipe! If you don't want to register your workstation on your Chef Server, this one-liner will run the default recipe using chef-solo. Run it from the parent directory where the linux-chef-workstation directory is located. This command must be run as root or with sudo.

```
echo "cookbook_path ['$(pwd)']" > solo.rb; chef-solo -c solo.rb -o 'chef-dev-workstation'
```

If you want to install this for an existing user, simply change the attributes below to your username. Note that it will overwrite your .bash\_profile, .vimrc, and .nanorc. The setup recipe also adds the omnibus Ruby and gems to your user's path, and enables Ruby syntax highlighting for both GNU Nano and Vim. It also installs a basic ~/.rubocop.yml config file.

If you're new to test-driven cookbook development, you can get started right away by using the built-in tests that come bundled with this cookbook. 

After running the default recipe to set up your workstation, you can run the following from within the cookbook to execute Rubocop, ChefSpec, and Foodcritic tests:

```
strainer test
```

**Windows:**

Usage is fairly simple.  Either clone the git repo or just copy the windows-setup.rb recipe somewhere onto your Windows machine.  Then you can run the following command to set things up:

```
chef-apply \.windows-setup.rb
```

**Test Driven Development:**

For more information on Strainer, Rubocop, Foodcritic, and ChefSpec, check out these links:

Strainer - Harness for running test suites
https://github.com/customink/strainer

Rubocop - Checks your Ruby syntax
https://github.com/bbatsov/rubocop

Foodcritic - Lint tester for Chef cookbooks
http://www.foodcritic.io/

ChefSpec - Unit test framework for Chef, based on Rspec
https://github.com/sethvargo/chefspec


# Attributes
There are only two configurable attributes, and they are for the linux-setup recipe. They are the username and MD5 hashed password of your admin user:

```
default['admin']['username']
default['admin']['password']
```

The default username is "admin" and the default password is simply "password". Super secure eh? You should probably change this if you are going to use this recipe in the real world.

# Recipes
default.rb - This includes the linux-setup recipe.

linux-setup.rb - Installs the workstation environment on CentOS/RHEL flavored machines.

windows-setup.rb - Installs the workstation environment on Windows machines.

# Authors

Authors:: Sean Carolan (<scarolan@getchef.com>), Alex Vinyar (<alex@getchef.com>)

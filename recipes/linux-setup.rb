# encoding: UTF-8
#
# Cookbook Name:: chef-dev-workstation
# Recipe:: linux-setup
#
adminuser = node['admin']['username']

##############################################################################
# First create an admin user
##############################################################################
group adminuser do
  gid '1001'
  not_if "getent group #{adminuser}"
end

user adminuser do
  comment 'Admin User'
  uid '1001'
  home "/home/#{adminuser}"
  shell '/bin/bash'
  group adminuser
  supports manage_home: true
  password node['admin']['password']
  not_if "getent passwd #{adminuser}"
end

##############################################################################
# Give the admin user sudo rights
# Uncomment if you want your user to have sudo with NOPASSWD
##############################################################################
# template '/etc/sudoers' do
#  source 'sudoers.erb'
#  owner 'root'
#  group 'root'
#  mode '0440'
# end

##############################################################################
# More dots! Config files for the admin user
##############################################################################
dotfiles = %w{bash_profile nanorc vimrc rubocop.yml}

dotfiles.each do |file|
  template "/home/#{adminuser}/.#{file}" do
    source "#{file}.erb"
    owner adminuser
    group adminuser
    mode '0644'
  end
end

##############################################################################
# Pimp my Vim
##############################################################################
dirs = %w{.vim .vim/bundle .vim/autoload}

dirs.each do |dir|
  directory "/home/#{adminuser}/#{dir}" do
    owner adminuser
    group adminuser
    mode '0755'
  end
end

remote_file "/home/#{adminuser}/.vim/autoload/pathogen.vim" do
  source 'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim'
  owner adminuser
  group adminuser
end

git "/home/#{adminuser}/.vim/bundle/vim-sensible" do
  repository 'git://github.com/tpope/vim-sensible.git'
  user adminuser
  group adminuser
end

git "/home/#{adminuser}/.vim/bundle/syntastic" do
  repository 'git://github.com/scrooloose/syntastic.git'
  user adminuser
  group adminuser
end

##############################################################################
# Lets install some packages!
##############################################################################
package_list = %w{git libxml2-devel libxslt-devel nano emacs}

package_list.each do |pack|
  package pack
end

# These gems have to have their versions constrained for compatibility
gem_package 'berkshelf' do
  version '= 2.0.12'
end

gem_package 'json' do
  version '<= 1.7.7'
end

gem_package 'foodcritic' do
  version '>= 3.0'
end

# The rest do not need versions constraints
gems = %w{test-kitchen kitchen-vagrant chefspec strainer rubocop ruby-wmi knife-essentials knife-windows knife-spork knife-ec2 knife-vsphere}
gems.each do |gem|
  gem_package gem
end

# encoding: UTF-8

# Download Sublime
remote_file 'c:/chef/Sublime_Text_2.0.2_x64_Setup.exe' do
  source 'http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64%20Setup.exe'
end

# Install Sublime
batch 'install_sublime' do
  code 'c:\chef\Sublime_Text_2.0.2_x64_Setup.exe /VERYSILENT /NORESTART'
  not_if { ::File.exists?('C:\Program Files\Sublime Text 2\sublime_text.exe') }
end

# Download Notepad++
remote_file 'c:/chef/npp.6.4.5.Installer.exe' do
  source 'http://download.tuxfamily.org/notepadplus/6.4.5/npp.6.4.5.Installer.exe'
end

# Install Notepad++
batch 'install_notepad++' do
  code 'c:\chef\npp.6.4.5.Installer.exe /S'
  not_if { ::File.exists?('C:\Program Files (x86)\Notepad++\notepad++.exe') }
end

powershell_script 'Setup setup powershell Aliases' do
  code <<-EOH
  $some_variable = Split-Path $PROFILE -Parent
  if(!(Test-Path $some_variable)){New-Item -Type directory $some_variable}
  'new-alias n "C:\Program Files (x86)\Notepad++\notepad++.exe" -force'    | Out-File $PROFILE
  'new-alias s "C:\Program Files\Sublime Text 2\sublime_text.exe" -force'  | Out-File $PROFILE -Append
  'new-alias k knife -force'                                               | out-file $profile -append
  'new-alias chef chef-client -force'                                      | Out-File $PROFILE -Append
  'remove-item alias:cd ; set-alias cd pushd -force'                       | Out-File $PROFILE -Append
  EOH
end

# Setup Environment variable for favorite editor
batch 'set_editor' do
  code 'setx EDITOR "\"%ProgramFiles%\Sublime Text 2\sublime_text.exe\" --wait"'
end

# Enable QuickEdit mode for Powershell and CMD
powershell_script 'Enable quick edit mode' do
  code 'set-ItemProperty -Path HKCU:\Console -Name QuickEdit -Value 1'
end

# Download Git
remote_file 'c:/chef/Git-1.8.5.2-preview20131230.exe' do
  source 'https://msysgit.googlecode.com/files/Git-1.8.5.2-preview20131230.exe'
end

batch 'install_git' do
  code 'c:\chef\Git-1.8.5.2-preview20131230.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /LOG="%temp%\git-installer.log" /NORESTART'# /SAVEINF="C:\Temp\git-settings.txt"'
  not_if { ::File.exists?('C:\Program Files (x86)\Git\cmd\git.exe') && ::File.exists?('C:\Program Files (x86)\Git\bin\git.exe') }
  # code 'c:\chef\Git-1.8.5.2-preview20131230.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /LOG="C:\Temp\git-installer.log" /NORESTART'# /SAVEINF="C:\Temp\git-settings.txt"'
  notifies :run, 'batch[set_path_for_git]'
end

batch 'set_path_for_git' do
  code 'setx PATH "%path%;C:\Program Files (x86)\Git\cmd;C:\Program Files (x86)\Git\bin\;"'
  action :nothing
  not_if "set path|grep -i 'C:\\Program Files (x86)\\Git\\cmd'"
end

# Setup gems
# Gems with version constraints
gem_package 'berkshelf' do
  version '= 2.0.12'
end

gem_package 'json' do
  version '<= 1.7.7'
end

gem_package 'foodcritic' do
  version '>= 3.0'
end

# Gems without version constraints
gems = %w{test-kitchen kitchen-vagrant chefspec strainer rubocop ruby-wmi knife-essentials knife-windows knife-spork knife-ec2 knife-vsphere}
gems.each do |gem|
  gem_package gem
end

# ## Download Vagrant
# remote_file 'c:/chef/Vagrant_1.4.3.msi'
#   source 'https://dl.bintray.com/mitchellh/vagrant/Vagrant_1.4.3.msi'
# end

# ## Download Virtual box
# remote_file 'c:/chef/VirtualBox-4.3.6-91406-Win.exe'
#   source 'http://download.virtualbox.org/virtualbox/4.3.6/VirtualBox-4.3.6-91406-Win.exe'
# end

# ## Download Packer
# remote_file "c:/chef/0.5.1_windows_amd64.zip" do
#   source "https://dl.bintray.com/mitchellh/packer/0.5.1_windows_amd64.zip"
# end

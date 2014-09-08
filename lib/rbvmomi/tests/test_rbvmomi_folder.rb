gem 'nokogiri', '=1.5.5'
require 'rbvmomi'

vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: 'true'
rootFolder = vim.serviceInstance.content.rootFolder
dc = vim.serviceInstance
#find_datacenter("RHIC-vmware") or fail "datacenter not found"
vm = dc.rootFolder.find_vm("New-Test-Clone") or fail "VM not found"
puts vm.disks
dc = rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter).find { |x| x.name == "RHIC-VMware" } or fail "datacenter not found"

#puts rootFolder.inspect
vm = rootFolder.traverse("/VirtualMachine/New-Test-Clone", RbVmomi::VIM::Folder, false)
puts vm.disks

#puts vm.inspect            

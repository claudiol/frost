gem 'nokogiri', '=1.5.5'
require "rbvmomi"

vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: true
serviceinst = vim.serviceInstance

dc = serviceinst.find_datacenter "RHIC-VMware"

vms = vim.serviceContent.viewManager.CreateContainerView({
              :container  => dc.vmFolder,
              :type       =>  ["VirtualMachine"],
              :recursive  => true
            }).view

propertyCollector = vim.serviceContent.propertyCollector

options = {}
list = propertyCollector.collectMultiple(vms, options[:folder])

vm = dc.find_vm "New-Lester-VM-2"

#task = vm.PowerOnVM_Task

#puts task



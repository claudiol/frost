require "rbvmomi"

vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: true

serviceinst = vim.serviceInstance

dc = serviceinst.find_datacenter "RHIC-VMware"
vm = dc.find_vm "New-Lester-VM-2"

task = vm.PowerOnVM_Task

puts task



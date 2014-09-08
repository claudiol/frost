#!/usr/bin/env ruby
###gem 'nokogiri', '=1.5.5'
require 'rbvmomi'

VIM = RbVmomi::VIM

vm_name = "New-Lester-VM-2"
vim = VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', ssl: true, insecure: true
dc = vim.serviceInstance.find_datacenter("RHIC-VMware") or abort "datacenter not found"
vmFolder = dc.vmFolder
hosts = dc.hostFolder.children
rp = hosts.first.resourcePool
vm_cfg = {
   :name => vm_name,
   :deviceChange => [
  {
  :operation => :add,
  :device => VIM.VirtualE1000(
  :key => 0,
  :deviceInfo => {
  :label => 'Network Adapter 2',
  :summary => 'VM Network'
},
  :backing => VIM.VirtualEthernetCardNetworkBackingInfo(
  :deviceName => 'VM Network'
),
  :addressType => 'generated'
)
}
]
}
###vmFolder.CreateVM_Task(:config => vm_cfg, :pool => rp).wait_for_completion
task = vmFolder.ReconfigVM_Task(:config => vm_cfg, :pool => rp)

#puts task.inspect
puts task



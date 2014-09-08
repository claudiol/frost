#!/usr/bin/env ruby
###gem 'nokogiri', '=1.5.5'
require 'rbvmomi'

VIM = RbVmomi::VIM

vm_name = "New-Lester-VM-7"
vim = VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', ssl: true, insecure: true
dc = vim.serviceInstance.find_datacenter("RHIC-VMware") or abort "datacenter not found"
vmFolder = dc.vmFolder
hosts = dc.hostFolder.children
rp = hosts.first.resourcePool
vm_cfg = {
   :name => vm_name,
   :guestId => 'otherGuest',
   :files => { :vmPathName => '[datastore1]' },
   :numCPUs => 1,
   :memoryMB => 128,
   :deviceChange => [
   {
      :operation => :add,
      :device => VIM.VirtualLsiLogicController(
      :key => 1000,
      :busNumber => 0,
      :sharedBus => :noSharing
   )
}, {
  :operation => :add,
  :fileOperation => :create,
  :device => VIM.VirtualDisk(
  :key => 0,
  :backing => VIM.VirtualDiskFlatVer2BackingInfo(
  :fileName => '[datastore1]',
  :diskMode => :persistent,
  :thinProvisioned => true
),
  :controllerKey => 1000,
  :unitNumber => 0,
  :capacityInKB => 4000000
)
}, {
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
],
:extraConfig => [
{
:key => 'bios.bootOrder',
:value => 'ethernet0'
}
]
}
###vmFolder.CreateVM_Task(:config => vm_cfg, :pool => rp).wait_for_completion
task = vmFolder.CreateVM_Task(:config => vm_cfg, :pool => rp)

#puts task.inspect
puts task



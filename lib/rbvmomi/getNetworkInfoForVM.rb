gem 'nokogiri', '=1.5.5'
require "rbvmomi"
require 'pp'
 
VIM = RbVmomi::VIM
hyper = '10.15.69.156'
vim = RbVmomi::VIM.connect :host => hyper, :user => 'root', :password => 'vmware', :insecure => true

dc = vim.serviceInstance.find_datacenter("RHIC-VMware") or abort "datacenter not found"
vm = dc.find_vm "New-Lester-VM-2"


vmHardwareInfo = vm.config.hardware

vmHardwareInfo.device.each do | device |
   puts "Device: #{device.deviceInfo.label} \t Summary: #{device.deviceInfo.summary}"
end

vm_cfg = {
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
#vmFolder = dc.vmFolder
#hosts = dc.hostFolder.children
#rp = hosts.first.resourcePool
#task = vm.ReconfigVM_Task(:spec=> vm_cfg).wait_for_completion
#puts task




require 'rubygems'
require 'rbvmomi'
require 'pp'
#require 'alchemist'
 
hyper = '10.15.69.156'
vim = RbVmomi::VIM.connect :host => hyper, :user => 'root', :password => 'vmware', :insecure => true
 
#
# get current time
#
vim.serviceInstance.CurrentTime
 
#
# get datacenter
#
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.Datacenter.html
dc = vim.serviceInstance.find_datacenter
 
# get host object
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.HostSystem.html
host = dc.hostFolder.children.first.host.first
 
#
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.host.HardwareInfo.html
#
# host.hardware
#
puts host.hardware.memorySize #.bytes.to.megabytes
puts host.hardware.cpuInfo.numCpuCores
 
#
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.host.RuntimeInfo.html
#
puts host.summary.runtime.powerState
 
#
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.host.Summary.QuickStats.html
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.host.Summary.html
puts host.summary.quickStats.overallMemoryUsage #.megabytes
puts host.summary.quickStats.overallCpuUsage
puts host.summary.config.name
 
#
# Product Info
#
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.AboutInfo.html
#
puts host.summary.config.product.fullName
puts host.summary.config.product.apiType
puts host.summary.config.product.apiVersion
puts host.summary.config.product.osType
puts host.summary.config.product.productLineId
puts host.summary.config.product.vendor
puts host.summary.config.product.version
 
# List all VM
# http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/vim.VirtualMachine.html
vm = dc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine).find do |x|
   puts x.name
   puts x.summary.config.memorySizeMB
   puts x.summary.config.numCpu
   puts x.summary.config.numEthernetCards
   puts x.summary.config.numVirtualDisks
end

gem 'nokogiri', '=1.5.5'
require "rbvmomi"

vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: true

serviceinst = vim.serviceInstance

fileMgr = serviceinst.content.fileManager


dc = vim.serviceInstance.find_datacenter("RHIC-VMware") or abort "datacenter not found"

folder = dc.vmFolder.childEntity.grep(RbVmomi::VIM::Folder).find { |x| x.name == "RapidClone-Lock" } 
puts folder

if folder.nil?
   puts "RapidClone-Lock not found!"
else
   puts "RapidClone-Lock found!"
   puts "Deleting RapidClone-Lock!"
   result = folder.UnregisterAndDestroy_Task
   puts result
end


value = {}

value[:name] = "RapidClone-Lock"
folder = dc.vmFolder.CreateFolder(value)

puts folder.childType




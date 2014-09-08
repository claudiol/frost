gem 'nokogiri', '=1.5.5'
require "rbvmomi"

vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: true

serviceinst = vim.serviceInstance

customizationSpecMgr = serviceinst.content.customizationSpecManager

info = customizationSpecMgr.info

puts "Found that we have #{info.count} Customization Spec ..."
info.each do | spec |
   puts "Name       : #{spec.name}"
   puts "Type       : #{spec.type}"
   puts "Change Version: #{spec.changeVersion}"
   puts "Description: #{spec.description}"
   puts "Last Update: #{spec.lastUpdateTime}"
end


#changeVersion*	xsd:string	

#The changeVersion is a unique identifier for a given version of the configuration. Each change to the configuration will update this value. This is typically implemented as an ever increasing count or a time-stamp. However, a client should always treat this as an opaque string.

#If specified when updating a specification, the changes will only be applied if the current changeVersion matches the specified changeVersion. This field can be used to guard against updates that has happened between the configInfo was read and until it is applied.
#description	xsd:string	

#Description of the specification.
#lastUpdateTime*	xsd:dateTime	

#Time when the specification was last modified. This time is ignored when the CustomizationSpecItem containing this is used as an input to CustomizationSpecManager.create.
#name	xsd:string	

#Unique name of the specification.
#type	xsd:string	

#Guest operating system for this specification (Linux or Windows). 




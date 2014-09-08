#
# Script: add_interface_to_vm.rb
# Purpose: Adds a network interface to an existing VM in vsphere using the Fog API
#
# Flow:
# - Creates a connection object using the credentials pased in
# - 

gem 'nokogiri', '=1.5.5'
gem 'fog', '=1.19.0'
require 'fog'
require 'pp'

if ARGV.count < 1 || ARGV.count > 2
   puts "#{$0} <VM Name>"
   exit
end
vm_name = ARGV[0]
puts "Verifying that #{vm_name} exists ..." if (@debug)

def get_virtual_machine_id ( connection, vm_name )
   response = connection.list_virtual_machines
   # The response will give you a list of VMs
   #     Example: {"id"=>"50186f83-0b86-60c5-8f87-ef5afa516163", "name"=>"New-Lester-VM-2", "uuid"=>"421889b5-32cf-5006-55e1-566832b9471b", "template"=>false, "parent"=>Folder("group-v3"), "hostname"=>nil, "operatingsystem"=>nil, "ipaddress"=>nil, "power_state"=>"poweredOn", "connection_state"=>"connected", "hypervisor"=>#<Proc:0x000000039cf998@/opt/rh/ruby193/root/usr/share/gems/gems/fog-1.19.0/lib/fog/vsphere/compute.rb:149>, "tools_state"=>"toolsNotInstalled", "tools_version"=>"guestToolsNotInstalled", "memory_mb"=>128, "cpus"=>1, "corespersocket"=>1, "overall_status"=>"red", "guest_id"=>"otherGuest", "mo_ref"=>"vm-97", "datacenter"=>#<Proc:0x000000039cfab0@/opt/rh/ruby193/root/usr/share/gems/gems/fog-1.19.0/lib/fog/vsphere/compute.rb:147>, "cluster"=>#<Proc:0x000000039cfa38@/opt/rh/ruby193/root/usr/share/gems/gems/fog-1.19.0/lib/fog/vsphere/compute.rb:148>, "resource_pool"=>#<Proc:0x000000039cf948@/opt/rh/ruby193/root/usr/share/gems/gems/fog-1.19.0/lib/fog/vsphere/compute.rb:150>, "mac_addresses"=>#<Proc:0x000000039cf8d0@/opt/rh/ruby193/root/usr/share/gems/gems/fog-1.19.0/lib/fog/vsphere/compute.rb:154>, "path"=>"/Datacenters/RHIC-VMware/vm", "relative_path"=>"RHIC-VMware"}

   # We want to get the vm_id
   vm_id = nil
   response.each do | vm |
      if vm['name'] == vm_name
        vm_id = vm['id']  # We found the VM so let's use teh vm_id
        return vm_id
      end
   end
end

credentials = {
    :provider         => "vsphere",
    :vsphere_username => "root",
    :vsphere_password => "vmware",  # You can put these in the .fog file on your home dir to test
    :vsphere_server   => "10.15.69.156",
    :vsphere_ssl      => true,
    :vsphere_expected_pubkey_hash => "93417b5bc1dbb140bdb9ec88df4ffa9ecd2525cf7e8f586ecb1e244106b5914b"
}

connection = Fog::Compute.new(credentials)

puts "Retrieving the VM id for VM [ #{vm_name} ] ..." if (@debug)
vm_id = get_virtual_machine_id(connection, vm_name)
if vm_id.nil?
   puts "Could not find the VM [ #{vm_name} ] ... exiting"
else
   puts "Found the VM [ #{vm_name} ]!"
end 

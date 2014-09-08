gem 'nokogiri', '=1.5.5'
gem 'fog', '=1.19.0'
require 'fog'
require 'pp'

#
# OUTPUT for list of interfaces looks like this: 
#{:id=>"VirtualE1000", :name=>"VirtualE1000", :datacenter=>"RHIC-VMware", :servertype=>"rhel6_64Guest"}
{:id=>"VirtualVmxnet3", :name=>"VirtualVmxnet3", :datacenter=>"RHIC-VMware", :servertype=>"rhel6_64Guest"}
#

credentials = {
    :provider         => "vsphere",
    :vsphere_username => "root",
    :vsphere_password => "<ADD PASSWORD>", 
    :vsphere_server   => "<ADD IP>",
    :vsphere_ssl      => true,
    :vsphere_expected_pubkey_hash => "<Add pubkey hash>" # You will get this the first time you run this
}

connection = Fog::Compute.new(credentials)

begin
 interface_types = connection.list_interface_types( { :datacenter => "RHIC-VMware", :servertype => "rhel6_64Guest"} )

  interface_types.each do | type |
   puts "Interface ID: #{type[:id]} \t\t Interface Name: #{type[:name]}"
  end
rescue => ex
  puts ex
end

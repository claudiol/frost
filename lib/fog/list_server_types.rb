gem 'nokogiri', '=1.5.5'
gem 'fog', '=1.19.0'
require 'fog'
require 'pp'

credentials = {
    :provider         => "vsphere",
    :vsphere_username => "root",
    :vsphere_password => "<ADD PASSWORD>",
    :vsphere_server   => "<ADD IP>",
    :vsphere_ssl      => true,
    :vsphere_expected_pubkey_hash => "93417b5bc1dbb140bdb9ec88df4ffa9ecd2525cf7e8f586ecb1e244106b5914b"
}

connection = Fog::Compute.new(credentials)

begin
  # {:id=>"eComStation2Guest", :name=>"eComStation2Guest", :family=>"otherGuestFamily", :fullname=>"Serenity Systems eComStation 2", :datacenter=>nil}
 server_types = connection.list_server_types

  server_types.each do | type |
   puts "Name: %20s\t\t Type ID: #{type[:id]} " % "#{type[:name]}"  
  end
rescue => ex
  puts ex
end

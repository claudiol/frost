###################################
#
# CloudForms Automate Method: Dialog_Hot_Plug_Variables
#
# This method is used to modify memory to existing vm.
#
###################################
begin
  # Method for logging
  def log(level, message)
    @method = 'Dialog_Hot_Plug_Variables'
    $evm.log(level, "#{@method} - #{message}")
  end

  $evm.log("info", "#{@method} - ================================= EVM Automate Method Started")

  # Get VM object
  vm = $evm.root['vm']

  @action = 'memory'

  gem 'nokogiri', '=1.5.5'
  require 'rbvmomi'

  @vm_hotplug = Hash.new

  def get_values(vm)
    vim = RbVmomi::VIM.connect host: vm.ext_management_system.ipaddress, user: vm.ext_management_system.authentication_userid, password: vm.ext_management_system.authentication_password, insecure: 'true'
    rootFolder = vim.serviceInstance.content.rootFolder
    dc = vim.serviceInstance.inspect
    dc = rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter).find { |x| x.name == "#{vm.ems_cluster_name}" } or fail "datacenter not found"

    vminfo = dc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine).find {
        |x|
      if x.name == "#{vm.name}"
        @vm_hotplug[:ems_ref] = x.to_s[/VirtualMachine(.*)/,1].gsub!(/[()]|\"|\"?$/, '').to_s
        @vm_hotplug[:name] = x.name.to_s
        @vm_hotplug[:version] = x.config.version.to_s
        @vm_hotplug[:memoryHotAddEnabled] = x.config.memoryHotAddEnabled.to_s
        @vm_hotplug[:hotPlugMemoryLimit] = x.config.hotPlugMemoryLimit.to_i
        @vm_hotplug[:hotPlugMemoryIncrementSize] = x.config.hotPlugMemoryIncrementSize.to_i
        @vm_hotplug[:cpuHotAddEnabled] = x.config.cpuHotAddEnabled.to_s
      end
    }
    return @vm_hotplug
  end

  vm_data = get_values(vm)
  $evm.log("info", "#{@method} - ====== #{vm_data.inspect}")

  @vm_memory_cpu = vm.hardware['memory_cpu']
  $evm.log("info", "===== EVM Automate Method: <#{@method}> vm_memory_cpu: #{@vm_memory_cpu}")

  @vm_numvcpus = vm.hardware['numvcpus']
  $evm.log("info", "===== EVM Automate Method: <#{@method}> vm_numvcpus: #{@vm_numvcpus}")

  case @action
    when "memory"
      vm_mem = @vm_memory_cpu.to_i / 1024
      mem_array = []
      default_val = ["#{@vm_memory_cpu / 1024} GB (Current)", @vm_memory_cpu.to_i]
      mem_array << default_val

      power_state = vm.attributes['power_state']
      if power_state == "off" || power_state == "suspended"
        log(:info, "VM is powered off")
        count = 1
        mem_limit = '1011' # Set that lowest memory is 1011GB
      else
        if vm_data[:memoryHotAddEnabled] == "true"
          count = vm_mem
          # If hotPlugMemoryLimit is enabled then get the limits from vCenter
          mem_limit = vm_data[:hotPlugMemoryLimit].to_i / 1024
        else
          count = 1
          # Else use the vCenter 5.1 Limits
          mem_limit = '1011'
        end
      end

      begin
        #$evm.log("info", "===== EVM Automate Method: <#{@method}> mem_val: #{mem_val}, mem_array: #{mem_array}")
        val = []
        val << "#{count} GB"
        val << "#{count * 1024}"
        mem_array << val
        count +=1;
      end until count > mem_limit.to_i

      list_values = {
          'sort_by' => :none,
          'data_type' => :string,
          'required' => :true,
          'values' => mem_array
      }

      $evm.log("info", "===== EVM Automate Method: <#{@method}> display drop-down: #{list_values}")
      list_values.each {|k,v| $evm.object[k] = v }

    when "cpu"
      cpu_array = []
      default_val = [nil,nil]
      cpu_array << default_val
      for n in 1..12
        val = []
        val << n
        val << n
        cpu_array << val
      end

      list_values = {
          'sort_by' => :none,
          'data_type' => :integer,
          'required' => :true,
          'values' => cpu_array
      }
      $evm.log("info", "===== EVM Automate Method: <#{@method}> display drop-down: #{list_values}")
      list_values.each {|k,v| $evm.object[k] = v }


  end


  $evm.log("info", "#{@method} - ================================= EVM Automate Method Ended")



  ############
  # Exit method
  #

  log(:info, "CloudForms Automate Method Ended")
  exit MIQ_OK

    #
    # Set Ruby rescue behavior
    #
rescue => err
  log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_ABORT
end
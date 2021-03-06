require 'rbvmomi'
vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', ssl: true, insecure: true

taskmgr = vim.serviceInstance.content.taskManager                                                                                                                                               
argv=[]
ARGV.each do|a|
  argv=a
end 
task = argv #Example: "task-220" 

puts "Retrieving Info for Task #{task} ..."
recent_tasks = taskmgr.recentTask
#puts "#{taskmgr.description.state} ..."
count = 0
recent_tasks.each do |t|
   count += 1
   if t.info.key == task
     puts "Found Info for Task #: #{t.info.key} Result: #{t.info.result}  State: #{t.info.state}"
   end
end
puts "Looked at #{count}  tasks."

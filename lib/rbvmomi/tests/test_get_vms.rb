require "rbvmomi"

@vim = RbVmomi::VIM.connect host: '10.15.69.156', user: 'root', password: 'vmware', insecure: true

pc = @vim.serviceInstance.content.propertyCollector                                                                                                                               
viewmgr = @vim.serviceInstance.content.viewManager                                                                                                                                               
rootFolder = @vim.serviceInstance.content.rootFolder

vmview = viewmgr.CreateContainerView({:container => rootFolder,                                                                                                                                  
                                      :type => ['VirtualMachine'],                                                                                                                                            
                                       :recursive => true})                                                                                                                                                                                                                                                                                                        
filterSpec = RbVmomi::VIM.PropertyFilterSpec(                                                                                                                                                    
            :objectSet => [                                                                                                                                                                              
                :obj => vmview,                                                                                                                                                                          
                :skip => true,                                                                                                                                                                           
                :selectSet => [                                                                                                                                                                          
                    RbVmomi::VIM.TraversalSpec(                                                                                                                                                          
                        :name => "traverseEntities",                                                                                                                                                     
                        :type => "ContainerView",                                                                                                                                                        
                        :path => "view",                                                                                                                                                                 
                        :skip => false                                                                                                                                                                   
                    )]                                                                                                                                                                                   
            ],                                                                                                                                                                                           
            :propSet => [                                                                                                                                                                                
                { :type => 'VirtualMachine', :pathSet => ['name']}                                                                                                                                                     
            ]                                                                                                                                                                                            
        )                                                                                                                                                                                                
result = pc.RetrieveProperties(:specSet => [filterSpec]) 

puts result.inspect

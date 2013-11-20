action :enable do
  service new_resource.service do
    provider  Chef::Provider::Service::Upstart
    action    :nothing
    supports  [:enable,:start,:restart,:stop]
  end
  
  # -- write upstart file -- #
  template "/etc/init/#{new_resource.service}.conf" do
    cookbook "lifeguard"
    source "lifeguard-upstart.conf.erb"
    mode 0644
    variables({ :service => new_resource })
    
    notifies :enable, "service[#{new_resource.service}]"

    if new_resource.restart
      notifies :restart, "service[#{new_resource.service}]"
    end
    
  end    
end

#----------

action :start do
  # -- start service -- #
  service new_resource.service do
    provider Chef::Provider::Service::Upstart
    action :start
  end
  
end

#----------

action :restart do
  # -- restart service -- #
  service new_resource.service do
    provider Chef::Provider::Service::Upstart
    action :start
  end
  
end

#----------

action :stop do
  # -- stop service -- #
  service new_resource.service do
    provider Chef::Provider::Service::Upstart
    action :stop
  end
  
end

#----------

action :remove do
  file "/etc/init/#{new_resource.service}.conf" do
    action :delete
  end
end
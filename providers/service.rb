action :enable do
  # -- Campfire settings -- #
  
  campfire = false
  
  if (new_resource.campfire || node.lifeguard.campfire_by_default) && node.lifeguard.campfire_enabled
    if node.lifeguard.campfire_account && node.lifeguard.campfire_token && node.lifeguard.campfire_room
      campfire = {
        account:  node.lifeguard.campfire_account,
        token:    node.lifeguard.campfire_token,
        room:     node.lifeguard.campfire_room
      }
    else
      raise "Asked to enable Campfire in Lifeguard, but account, token and room are not specified."
    end
  end

  # -- Slack settings -- #
  
  slack = false

  if (new_resource.slack || node.lifeguard.slack_by_default) && node.lifeguard.slack_enabled
    if node.lifeguard.slack_team && node.lifeguard.slack_token && node.lifeguard.slack_channel
      slack = {
        team:     node.lifeguard.slack_team,
        token:    node.lifeguard.slack_token,
        channel:  node.lifeguard.slack_channel
      }
    else
      raise "Asked to enable Slack in Lifeguard, but team, token and channel are not specified."
    end
  end
  
  
  case node.lifeguard.init_style
  when "upstart" 
    # -- Upstart -- #

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
      variables({ :service => new_resource, :campfire => campfire })
    
      notifies :enable, "service[#{new_resource.service}]"

      if new_resource.restart
        notifies :restart, "service[#{new_resource.service}]"
      end
    
    end
      
  when "runit"
    # -- Runit -- #
    
    env = (new_resource.env||{}).clone
    
    if new_resource.dir
      env["HOME"] = new_resource.dir
    end
    
    if campfire
      env["CAMPFIRE_ACCOUNT"] = campfire.account
      env["CAMPFIRE_TOKEN"]   = campfire.token
      env["CAMPFIRE_ROOM"]    = campfire.room
    end
    
    if slack
      env["SLACK_TEAM"]       = slack.team
      env["SLACK_TOKEN"]      = slack.token
      env["SLACK_CHANNEL"]    = slack.channel
    end
    
    runit_service new_resource.service do
      action            :enable
      run_template_name "lifeguard_service"
      cookbook          "lifeguard"
      env               env
      default_logger    true
      options({
        :service  => new_resource,
        :campfire => campfire,
        :slack    => slack
      })
    end
    
  else
    raise "Unknown lifeguard init_style: #{node.lifeguard.init_style}. upstart and runit supported." 
  end
end

#----------

action :start do
  case node.lifeguard.init_style
  when "upstart"
    # -- start service -- #
    service new_resource.service do
      provider Chef::Provider::Service::Upstart
      action :start
    end
    
  when "runit"
    runit_service new_resource.service do
      action :start
    end
  
  else
    raise "Unknown lifeguard init_style: #{node.lifeguard.init_style}. upstart and runit supported."
  end
end

#----------

action :restart do
  case node.lifeguard.init_style
  when "upstart"
    # -- restart service -- #
    service new_resource.service do
      provider Chef::Provider::Service::Upstart
      action :restart
    end
  
  when "runit"
    runit_service new_resource.service do
      action :restart
    end
    
  else
    raise "Unknown lifeguard init_style: #{node.lifeguard.init_style}. upstart and runit supported."
  end
end

#----------

action :stop do
  case node.lifeguard.init_style
  when "upstart"
    # -- stop service -- #
    service new_resource.service do
      provider Chef::Provider::Service::Upstart
      action :stop
    end
  
  when "runit"
    runit_service new_resource.service do
      action :stop
    end
    
  else
    raise "Unknown lifeguard init_style: #{node.lifeguard.init_style}. upstart and runit supported."
  end
end

#----------

action :remove do
  case node.lifeguard.init_style
  when "upstart"
    file "/etc/init/#{new_resource.service}.conf" do
      action :delete
    end
  
  when "runit"
    runit_service new_resource.service do
      action :disable
    end
    
  else
    raise "Unknown lifeguard init_style: #{node.lifeguard.init_style}. upstart and runit supported."
  end
end
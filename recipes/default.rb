# install nodejs
include_recipe "nodejs"

# Install lifeguard, unless we already have the version requested
execute "npm install -g lifeguard@#{node.lifeguard.version}" do
  path ["/usr/bin","/usr/local/bin"]
  not_if do
    begin
      json = `npm list -g lifeguard --json`
      obj = JSON.parse json
      
      if obj["dependencies"] && obj["dependencies"]["lifeguard"]["version"] == node.lifeguard.version
        true
      else
        false
      end
    rescue
      false
    end
  end
end

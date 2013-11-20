include_recipe "lifeguard"

lifeguard_service "Testing" do
  action    :enable
  service   "testing"
  command   "/bin/invalid_command"
  user      "root"
end
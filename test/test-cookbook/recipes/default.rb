# -- Install our test service -- #

include_recipe "lifeguard"

# Create a user
user "lifeguard_test" do
  action  :create
  system  true
end

cookbook_file "/usr/bin/lifeguard_test_service" do
  action  :create
  mode    0755
end

lifeguard_service "Lifeguard Test" do
  action  [:enable,:start]
  service "lifeguard_test_service"
  user    "lifeguard_test"
  command "/usr/bin/lifeguard_test_service"
end
  
  
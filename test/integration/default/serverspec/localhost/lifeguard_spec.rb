require "spec_helper"

# -- Ensure lifeguard is installed -- #

describe command("which lifeguard") do
  its(:stdout) { should include("lifeguard")}
end

# -- Ensure our test service command is installed -- #

describe file("/usr/bin/lifeguard_test_service") do
  it { should be_file }
  it { should be_executable }
end

# -- Ensure test service exists -- #

describe service("lifeguard_test_service") do
  it { should be_enabled }
  it { should be_running }
  #it { should be_monitored_by "lifeguard" }
end

describe process("lifeguard_test_service") do
  its(:user) { should match(/^lifeguard_test\s*$/) }
end

# -- Ensure test service is listening on port 9999 -- #

describe port(9999) do
  it { should be_listening("tcp") }
end

# -- test service 2 -- #

describe file("/etc/init/lifeguard_test_service2.conf") do
  its(:content) { should_not include("respawn limit")}
end

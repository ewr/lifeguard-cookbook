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

# FIXME: These can be used if specinfra ever learns about runit
#describe service("lifeguard_test_service") do
#  it { should be_enabled }
#  it { should be_running }
#end

describe command("sv check lifeguard_test_service") do
  its(:stdout) { should match(/lifeguard_test_service: \(pid \d+\)/)}
end

describe process("lifeguard_test_service") do
  its(:user) { should match(/^lifeguard_test\s*$/) }
end

# -- Ensure test service is listening on port 9999 -- #

describe port(9999) do
  it { should be_listening("tcp") }
end


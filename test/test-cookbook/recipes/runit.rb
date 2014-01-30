include_recipe "runit"

node.set.lifeguard.init_style = "runit"

include_recipe "lifeguard-test::default"
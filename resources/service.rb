actions :start, :stop, :restart, :remove
default_action :enable

attribute :name,      :kind_of => String, :name_attribute => true
attribute :service,   :kind_of => String
attribute :user,      :kind_of => String
attribute :dir,       :kind_of => String, :default => nil
attribute :command,   :kind_of => String
attribute :env,       :kind_of => Hash
attribute :path,      :kind_of => String
attribute :handoff,   :kind_of => [TrueClass, FalseClass], :default => false
attribute :campfire,  :kind_of => [TrueClass, FalseClass], :default => true
attribute :restart,   :kind_of => [TrueClass, FalseClass], :default => true
attribute :depends,   :kind_of => String, :default => nil
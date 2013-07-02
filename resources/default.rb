actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :required => false
attribute :group, :kind_of => String, :required => false
attribute :deploy_to, :kind_of => String, :required => false
attribute :repository, :kind_of => String, :required => true
attribute :git_reference, :kind_of => String, :default => "master"
attribute :deploy_key, :kind_of => String, :required => false

def initialize(*args)
  super
  @action = :create

  @run_context.include_recipe "git"
end

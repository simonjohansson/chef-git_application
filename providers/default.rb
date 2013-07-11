action :create do
  user = new_resource.user || new_resource.name
  group = new_resource.group || user
  deploy_key = new_resource.deploy_key || new_resource.name
  repository = new_resource.repository
  deploy_to = new_resource.deploy_to || "/opt/#{new_resource.name}"

  # Make sure the user exsists
  #
  user user do
    action :create
    home "/home/#{user}"
    shell "/bin/bash"
    supports :manage_home => true
  end

  unless group.nil?
    # Create our group and add the user to it.
    #
    group group do
      action :create
    end
    group group do
      action :modify
      members user
      append true
    end
  end

  directory deploy_to do
    owner user
    group group
    recursive true
  end

  # Unless we've been told not to, sync the code with the git repository.
  #
  unless new_resource.no_sync
    # Get the deploy key from the data-bag.
    #
    key_obj = data_bag_item('git_keys', deploy_key)

    # Deploy the git deploy key to the user.
    git_ssh_wrapper new_resource.name do
      owner user
      group group
      ssh_key_data key_obj["private_key"]
    end

    git deploy_to do
      repository repository
      reference new_resource.git_reference
      action :sync
      user user
      group group
      ssh_wrapper "/home/#{user}/.ssh/wrappers/#{new_resource.name}_deploy_wrapper.sh"
    end
  end

end


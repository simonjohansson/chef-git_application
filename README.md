#Resources
```
:name, :kind_of => String, :name_attribute => true
:user, :kind_of => String, :required => false
:group, :kind_of => String, :required => false
:deploy_to, :kind_of => String, :required => false
:repository, :kind_of => String, :required => false
:git_reference, :kind_of => String, :default => "master"
:deploy_key, :kind_of => String, :required => false
```

#Usage
Add it to the metadata

```
depends "git_application"
```

Use it in a recipe

```
git_application "coolApp" do
  user "coolApp"
  deploy_to "/opt/coolApp"
  repository "git@github.com:ORG/coolApp.git"
end
```

This will do the following.

* Installs git
* Creates a coolApp user (if it doesnt already exist)
* Creates /opt/coolApp (if it doesnt already exist)
* Gets the coolApp deploy key from a databag
* Puts the deploy key in the coolApp users ssh folder and takes care of authorized hosts and all that for you
* Pulls the code to the coolApp folder, with the ref you want.


# Databag

The LWRP will look in the databag git_keys for a item with id "coolApp" with the following layout

```
{
    "id": "coolApp",
    "private_key": "-----BEGIN RSA PRIVATE KEY-----\nMUMBOJUMBO\n-----END RSA PRIVATE KEY-----",
    "public_key": "ssh-rsa ........"
}

```

# Manual install

You don't want to do a manual install. Unless you're someone who wants to look under the covers before turning everything over to a cookbook.

Some assumptions:
* The GCE project `cheffian-supermarket` is my cloud, so FQDNs reflect this
* I've hacked my /etc/hosts to use `chefserver` and `supermarket` as the hostnames


## chefserver

Install and configure api_fqdn:

    apt-get update
    curl https://packagecloud.io/install/repositories/chef/stable/script.deb |  bash
    apt-get update
    apt-get install chef-server-core
    echo "api_fqdn \"$(hostname -f)\"" >> /etc/opscode/chef-server.rb
    chef-server-ctl reconfigure

Add orgs/user:

    chef-server-ctl user-create pdb Peter Burkholder pburkholder@getchef.com TestPassword -f pdb.pem
    chef-server-ctl org-create pdb_chef12_org pdb_chef12_org -f pdb_chef12_org.pem -a pdb
    echo "oc_id['administrators'] = ['pdb']" >> /etc/opscode/chef-server.rb
    chef-server-ctl reconfigure

Configure oc-id

* Navigate to https://chefserver/id
* Click the New Application button and fill in the application name and Redirect url
  * Name: supermarket
  * Redirect uri: https://<ip or name of supermarket server>/auth/chef_oauth2/callback
    * e.g.:
          https://supermarket/auth/chef_oauth2/callback
          http://supermarket/auth/chef_oauth2/callback
* After you click Submit you will be shown the Application Id and Secret strings which you must supply to Supermarket.  Copy these down, but don’t worry about losing them. You can always retrieve them from the /id/oauth/applications URL of your Chef server.



## Supermarket

Install:

    apt-get update
    curl https://packagecloud.io/install/repositories/chef/stable/script.deb | apt-get update
    apt-get install supermarket
    supermarket-ctl reconfigure

Configure `/etc/supermarket/supermarket.rb`, with the app_id and secret from above:

    default['supermarket']['chef_oauth2_app_id'] = '1fcce03a...67b822d1196'
    default['supermarket']['chef_oauth2_secret'] = '9836e5f7d65....b10178ac0d'
    default['supermarket']['chef_oauth2_url'] = 'https://chefserver-0.c.cheffian-supermarket.internal'
    default['supermarket']['chef_oauth2_verify_ssl'] = false

Reconfigure:

    supermarket-ctl reconfigure

Next:

https://supermarket-0.c.cheffian-supermarket.internal/sign-in

You'll be redirected to the `oc-id` service on chef-server. Sign-in with the credentials you used above, then accept the request to 'Authorize Supermarket to use your Chef account'

You should be in.

## Now, let's move on to uploading cookbooks...


#### Notes

These are all the Callback URLs that I authorized above:

    https://supermarket/auth/chef_oauth2/callback
    http://supermarket/auth/chef_oauth2/callback
    http://supermarket-0.c.cheffian-supermarket.internal/auth/chef_oauth2/callback
    https://supermarket-0.c.cheffian-supermarket.internal/auth/chef_oauth2/callback

## About authentication

As long as your ID remains signed in with the Chef server you'll be able to reauth with Supermarket just by connecting with ... (session id?)

URL for logout, https://supermarket-0.c.cheffian-supermarket.internal/id, is 404. Where you want to go is: https://chefserver/id

Actually, I can't seem to sign-out at all. Bug?

## Upload a cookbook from command-line

## Install/configure knife supermarket

The documentation in the README at https://github.com/cwebberOps/knife-supermarket is pretty good, so go read that and come back.

Now try:

    knife supermarket list

should be nothing back

Try uploading a cookbook, and you'll get:

    ERROR: Error uploading cookbook fetch_json_data to the Opscode Cookbook Site: lexical error: invalid char in json text.
                                   <html>  <head><title>301 Moved
                 (right here) ------^

Why? Because we're not authenticating as the correct user.

You can get the user.pem from the user-creation step, earlier, by downloading from the chefserver to a local `.chef` directory, and accessing with a `knife.rb` such as:

    current_dir = File.dirname(__FILE__)
    node_name                "pdb"   # the username setup with chef-server-ctl user-create
    client_key               "#{current_dir}/pdb.pem" # The key created by user-create subcommand
    chef_server_url          "https://chefserver/organizations/pdb_chef12_org" # The org created by chef-server-ctl org-create
    knife[:supermarket_site] = 'https://supermarket-0.c.cheffian-supermarket.internal' # Note FQDN and HTTPS

Now you can test `knife supermarket`:

    mkdir ./cookbooks
    chef generate cookbook cookbooks/empty_cookbook
    knife supermarket share test_cookbook -o ./cookbooks -c .chef/knife.rb


## Keys with Manage

    sudo chef-server-ctl install opscode-manage
    sudo opscode-manage-ctl reconfigure
    sudo chef-server-ctl reconfigure

Then, for your user, generage 

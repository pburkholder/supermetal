# Useful Links

The supermarket project doesn't have, AFAIK, useful walk-throughs. I hope to provide that here.

* https://www.chef.io/blog/2014/08/29/getting-started-with-oc-id-and-supermarket/
* https://github.com/chef/supermarket/wiki/Deployment
* https://github.com/chef/supermarket/wiki/Deployment


## Manual install

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
    echo "api_fqdn \"chefserver.cheffian.com\"" >> /etc/opscode/chef-server.rb
    chef-server-ctl reconfigure

Add orgs/user:

    chef-server-ctl user-create pdb Peter Burkholder pburkholder@getchef.com TestPassword -f pdb.pem
    chef-server-ctl user-create demo Fname Lname demo@chef.io DemoPassword -f demo.pem
    chef-server-ctl org-create demo_org demo_org -f demo_org.pem -a demo
    echo "oc_id['administrators'] = ['demo']" >> /etc/opscode/chef-server.rb
    chef-server-ctl reconfigure

Configure oc-id

* Navigate to https://chefserver/id
* Click the New Application button and fill in the application name and Redirect url
  * Name: supermarket
  * Redirect uri: https://<ip or name of supermarket server>/auth/chef_oauth2/callback
    * e.g.:
          https://supermarket.cheffian.com/auth/chef_oauth2/callback
          https://supermarket/auth/chef_oauth2/callback
* After you click Submit you will be shown the Application Id and Secret strings which you must supply to Supermarket.  Copy these down, but don’t worry about losing them. You can always retrieve them from the /id/oauth/applications URL of your Chef server.



## Supermarket

Install:

    apt-get update
    curl https://packagecloud.io/install/repositories/chef/stable/script.deb | curl
    apt-get install supermarket
    supermarket-ctl reconfigure

Configure `/etc/supermarket/supermarket.rb`, with the app_id and secret from above:

    default['supermarket']['chef_oauth2_app_id'] = '1fcce03a...67b822d1196'
    default['supermarket']['chef_oauth2_secret'] = '9836e5f7d65....b10178ac0d'
    default['supermarket']['chef_oauth2_url'] = 'https://chefserver.cheffian.com'
    default['supermarket']['chef_oauth2_verify_ssl'] = false


Reconfigure:

    supermarket-ctl reconfigure

Next:

https://supermarket.cheffian.com/sign-in

You'll be redirected to the `oc-id` service on chef-server. Sign-in with the credentials you used above, then accept the request to 'Authorize Supermarket to use your Chef account'

You should be in.

## Now, let's move on to uploading cookbooks...


#### Notes

## ssl testing

Even with ssl.verify off, `berks install` or `berks vendor` will fail when supermarket is using a self-signed certificate. So, how do we get around that?

Got /var/opt/supermarket/ssl/cacert.pem into local cacert.pem. 

### Get the CERT


    knife ssl fetch supermarket.cheffian.com
    # concatenate all your pems
    cd ....chef/trusted_certs
    cat &star.crt > cacert.pem

### openssl s_client

Cert verify with `openssl`

    openssl s_client -CAfile cacert.pem -connect supermarket.cheffian.com:443 -verify 0


### Faraday

But curl doesn't matter, since Berkshelf uses Faraday, so let's try with that:

    require 'faraday'
    print "Trying with no ssl options:\n"
    begin
        connection = Faraday::Connection.new 'https://supermarket-0.c.cheffian-supermarket.internal'
        p connection.get '/universe'
        p "WORKED\n\n\n"
    rescue Exception => e
        print e.message, "\n\n\n"
    end

    print "Trying with ssl ca_file options:\n"
    begin
        connection = Faraday::Connection.new 'https://supermarket-0.c.cheffian-supermarket.internal', :ssl => { :ca_file => './cacert.pem' }
        p connection.get '/universe'
        p "WORKED\n\n\n"
    rescue Exception => e
        print e.message, "\n\n\n"
    end

###  Berks

However, Berks doesn't have any options for specifying CA_file.  Hmmmm. Good news, the above script works when:

    export SSL_CERT_FILE=cacert.pem

Now attempts to use `berks` with the same SSL_CERT_FILE path set will work.

    berks vendor

should work.


### Berksfile?

Add this to your Berskfile:

    ENV['SSL_CERT_FILE'] = '/some/path/to/cacert.pem'


### Aside: Cert verify with `curl`

I can't get curl to work with self-signed cert, so don't count on Curl for helping you here. You'd think the following would work:

    curl -v --cacert cacert.pem https://supermarket.cheffian.com:443

But it doesn't. It would seem that since self-signed certs don't assert themselves as CAs that curl won't be happy (and probably berks neither). That is, that

    openssl x509 -in cacert.pem -inform pem -text -out certdata

won't contain:

    X509v3 Basic Constraints:
    CA:TRUE
    X509v3 Key Usage:
    Certificate Sign, CRL Sign

## callback notes

These are all the Callback URLs that I authorized above:

    https://supermarket.cheffian.com/auth/chef_oauth2/callback




# How it all fits together!

https://github.com/chef/omnibus-supermarket/blob/master/cookbooks/omnibus-supermarket/attributes/default.rb

Becomes /etc/supermarket/supermarket.rb

So, after you install omnibus-supermarket, you'll want a cookbook to
use the modify supermarket.rb

Wrap, wrap, baby???

The things to address are:
- ssl cert
- features -- currybot?

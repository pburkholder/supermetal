# Mirroring Cookbooks

Make a `Berksfile` with all the cookbooks you want:

    ENV['BERKSHELF_PATH']='./berkshelf'
    source "https://supermarket.chef.io"

    cookbook 'apt', '~> 2.0'
    cookbook 'aws', '~> 2.0'
    cookbook 'hostsfile', '~> 2.0'
    cookbook 'lvm', '~> 1.0'
    cookbook 'yum', '~> 3.0'
    cookbook 'yum-elrepo'
    cookbook 'yum-epel'
    cookbook 'docker', '~> 0.0'
    cookbook 'chef-client'

The use `berks vendor` to download all the required cookbooks to `./berks-cookbooks`

Now you can `cd berks-cookbooks` and install all to supermarket:

    for i in *; do knife supermarket share $i -c ../.chef/knife.rb -o . ; done

What about
ERROR: knife encountered an unexpected error
This may be a bug in the 'supermarket share' knife command or plugin
Please collect the output of this command with the `-VV` option before filing a bug report.
Exception: NameError: undefined local variable or method `method_name' for Chef::Cookbook::Metadata:Class

Happens here:

DEBUG: Staging /Users/pburkholder/Hack/supermetal/berks-cookbooks/logrotate/TESTING.md to /var/folders/hl/zf_j1bvs7_b18rj7bbsm35p00000gp/T/chef-logrotate-build20150213-90487-16e5h81/logrotate/TESTING.md
DEBUG: Generating metadata
ERROR: knife encountered an unexpected error
This may be a bug in the 'supermarket share' knife command or plugin
Please collect the output of this command with the `-VV` option before filing a bug report.
Exception: NameError: undefined local variable or method `method_name' for Chef::Cookbook::Metadata:Class

knife-supermarket 0.2.1 is latest

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

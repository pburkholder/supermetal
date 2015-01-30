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

You can get the user.pem from the user-creation step, earlier.... Or

##

== README

## Installation ##

``` sudo apt-get install libpq-dev```

### Rails commands ###

1. Start the server: ``` rails s ```
2. Start rails console: ``` rails c ```
3. Db migration: ``` rake db :migrate ```
4. Install dependencies: ``` bundle install ```
5. Create Model: ``` rails g model <modelname> ```
6. Add field to model ``` rails g migration AddMessageToInvite ```


### Production ###
1. Recompile assets:
    ```  RAILS_ENV=production rake assets:precompile ```

### Terminology suggestions ###
1. study circle
2. learning post

### Links ###
1. http://thelazylog.com/twitter-bootstrap-3-rails-4-fix-issue-which-prevents-fonts-from-loading/

## Notice ##
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/colearn.xyz/fullchain.pem. Your cert will
   expire on 2017-03-10. To obtain a new or tweaked version of this
   certificate in the future, simply run certbot-auto again. To
   non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le


### colearn.co
ubuntu@ip-172-31-38-222:~/colearn$ ./certbot-auto certonly
Requesting root privileges to run certbot...
  /home/ubuntu/.local/share/letsencrypt/bin/letsencrypt certonly
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Failed to find apache2ctl in PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

How would you like to authenticate with the ACME CA?
-------------------------------------------------------------------------------
1: Place files in webroot directory (webroot)
2: Spin up a temporary webserver (standalone)
-------------------------------------------------------------------------------
Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 1
Please enter in your domain name(s) (comma and/or space separated)  (Enter 'c'
to cancel):colearn.co
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for colearn.co

Select the webroot for colearn.co:
-------------------------------------------------------------------------------
1: Enter a new webroot
-------------------------------------------------------------------------------
Press 1 [enter] to confirm the selection (press 'c' to cancel): 1
Input the webroot for colearn.co: (Enter 'c' to cancel):/home/ubuntu/colearn/colearn/public
Waiting for verification...
Cleaning up challenges
Generating key (2048 bits): /etc/letsencrypt/keys/0001_key-certbot.pem
Creating CSR: /etc/letsencrypt/csr/0001_csr-certbot.pem

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/colearn.co/fullchain.pem. Your cert will
   expire on 2017-04-26. To obtain a new or tweaked version of this
   certificate in the future, simply run certbot-auto again. To
   non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le


### Images ###
	* https://pixabay.com/en/learn-word-scrabble-letters-wooden-1820039/


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

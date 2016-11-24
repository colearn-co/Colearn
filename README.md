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

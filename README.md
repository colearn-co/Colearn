== README ===

## Contribution ##
We storgly believe in building stuff together thats why we have open sourced colearn.
Please feel free to suggest new features and and file bugs. If you want to add new features or fix bugs/ issues and having trouble starting up, feel free to contact us at colearn.xyz@gmail.com or better use github issues to discuss.



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

### Helper method ###
```  User.where("referrer like '%codeforces%'").first.is_inactive? ```


### Images ###
	* https://pixabay.com/en/learn-word-scrabble-letters-wooden-1820039/


### TODO:
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



## License

Colearn is licensed under GNU Affero General Public License. For more information see [http://www.gnu.org/licenses/agpl-3.0.html](http://www.gnu.org/licenses/agpl-3.0.html)



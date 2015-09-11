### Restyaboard

Trello like kanban board. [Restyaboard](http://restya.com/board/) is based on [Restya platform] (http://restya.com/).

### Demo

[Demo](http://restya.com/board/demo.html)

### Install

* [Install](http://restya.com/board/install.html)
* [Configure](http://restya.com/board/install.html#configure)
* [Importing from trello](http://restya.com/board/install.html#import-trello)

### Upgrade

To upgrade, overwrite application files and apply respective DB script:

*  v0.1.1 to v0.1.2 - `/sql/upgrade-0.1.1-0.1.2.sql`

### Forum

* [Restya Google Group](https://groups.google.com/d/forum/restya)

### Known Issues

[Known Issues](http://restya.com/board/issues.html)

------------

### Current Status / Plans / Roadamap

To give you some idea about of our plans:

#### Immediate (cooking)

* Chat
* App
  * Simple app architecture
  * "Import from GitHub" sample app
  * Current API tweaks to accept other oAuth clients "properly"
* UI enhancements
* Better responsive mobile view
* Address some [known issues](http://restya.com/board/issues.html)
* Notifier iOS App (Possibly, Free and non-open source)


#### Next

* Email notifications
  * Brainstorm for "best" approach
* Refactor R framework
  * Our focus on shipping this somewhat bloated "ultra thin" R framework. Better use new "REST URL to DB Query builder" code once that is tested (?).
* Merge caching layer works (Or, only in commerical?)
* Marketplace for ecosystem
  * Allow developers to make money
* Apps listing platform
  * Find apps easily

------------

### Contributing

Our approach is similar to Magento. If anything is not clear, please [contact us](http://restya.com/contact.html?category=contributing).

All Submissions you make to Restya through GitHub are subject to the following terms and conditions:

* You grant Restya a perpetual, worldwide, non-exclusive, no charge, royalty free, irrevocable license under your applicable copyrights and patents to reproduce, prepare derivative works of, display, publicly perform, sublicense and distribute any feedback, ideas, code, or other information ("Submission") you submit through GitHub.
* Your Submission is an original work of authorship and you are the owner or are legally entitled to grant the license stated above.



### Build

Required sofware: nginx, php-fpm (with mbstring), PostgreSQL, ElasticSearch, Grunt

* `grunt less` - Converts LESS to CSS
* `grunt jst` - Converts EJS to JS
* `grunt watch` - Converts LESS to CSS and EJS to JS, automatically by "watching" for file changes
* `restyaboard_with_empty_data.sql` - Database generation script 
* `server/php/R/config.inc.php` - Database and other configurations
* `media` - Need write permission for php; can be `chmod 655` or `755` or `777` depending upon server configuration
* `grunt build:env` - Generates restyaboard.zip, deployable code (env - dev or live)

------------

### License

Copyright (c) 2014-2015 [Restya](http://restya.com/).

Dual License ([OSL 3.0](LICENSE.txt) & [Commercial License](http://restya.com/contact.html))

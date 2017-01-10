### Restyaboard

[![Build Status](https://travis-ci.org/RestyaPlatform/board.svg?branch=master)](https://travis-ci.org/RestyaPlatform/board) [![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/RestyaPlatform/board.svg)](http://isitmaintained.com/project/RestyaPlatform/board "Average time to resolve an issue") [![Percentage of issues still open](http://isitmaintained.com/badge/open/RestyaPlatform/board.svg)](http://isitmaintained.com/project/RestyaPlatform/board "Percentage of issues still open")

Trello like kanban board. [Restyaboard](http://restya.com/board/) is based on [Restya platform] (http://restya.com/).

### Status: Active

Project is active! Follow development in [dev](https://github.com/RestyaPlatform/board/tree/dev) branch

### Demo

[Demo](http://restya.com/board/demo)

### Install

* [Install](http://restya.com/board/install)
* [Configure](http://restya.com/board/install#configure)
* [Importing from trello](http://restya.com/board/install#import-trello)

### Upgrade

To upgrade, overwrite application files and apply respective DB script:

*  v0.1.1 to v0.1.2 - `/sql/upgrade-0.1.1-0.1.2.sql`
*  v0.1.2 to v0.1.3 - `/sql/upgrade-0.1.2-0.1.3.sql`
*  v0.1.3 to v0.1.4 - `/sql/upgrade-0.1.3-0.1.4.sql`
*  v0.1.4 to v0.1.5 - `/sql/upgrade-0.1.4-0.1.5.sql`
*  v0.1.5 to v0.1.6 - `/sql/upgrade-0.1.5-0.1.6.sql`
*  v0.1.6 to v0.2 - `/sql/upgrade-0.1.6-0.2.sql`
*  v0.2 to v0.2.1 - `/sql/upgrade-0.2-0.2.1.sql`
*  v0.2.1 to v0.3 - `/sql/upgrade-0.2.1-0.3.sql`

### Forum

* [Restya Google Group](https://groups.google.com/d/forum/restya)

------------

### Current Status / Plans / Roadamap

To give you some idea about of our plans:

#### Immediate (cooking)

* Chat
* Notifier iOS App (Possibly, Free and non-open source)


#### Next

* Refactor R framework
  * Our focus on shipping this somewhat bloated "ultra thin" R framework. Better use new "REST URL to DB Query builder" code once that is tested (?).
* Merge caching layer works (Or, only in commerical?)
* Marketplace for ecosystem
  * Allow developers to make money
* Apps listing platform
  * Find apps easily

------------

### Contributing

Our approach is similar to Magento. If anything is not clear, please [contact us](http://restya.com/contact?category=contributing).

You can help with translating Restyaboard via [transifex](https://www.transifex.com/restya/restyaboard/).

All Submissions you make to Restya through GitHub are subject to the following terms and conditions:

* You grant Restya a perpetual, worldwide, non-exclusive, no charge, royalty free, irrevocable license under your applicable copyrights and patents to reproduce, prepare derivative works of, display, publicly perform, sublicense and distribute any feedback, ideas, code, or other information ("Submission") you submit through GitHub.
* Your Submission is an original work of authorship and you are the owner or are legally entitled to grant the license stated above.



### Build

Required sofware: nginx, php-fpm (with mbstring), PostgreSQL, ElasticSearch, Grunt

* `grunt less` - Converts LESS to CSS
* `grunt jst` - Converts EJS to JS
* `grunt watch` - Converts LESS to CSS and EJS to JS, automatically by "watching" for file changes
* `restyaboard_with_empty_data.sql` - Database generation script 
* `server/php/config.inc.php` - Database and other configurations
* `media`, `client/img`, `tmp/cache` & `server/php/shell/*.sh` - Need write permission for php; can be `chmod 655` or `755` or `777` depending upon server configuration
* `grunt build:live` - Generates restyaboard.zip, deployable code. Replace your DB details in `build/live.json`.

------------

### License

Copyright (c) 2014-2016 [Restya](http://restya.com/).

Dual License ([OSL 3.0](LICENSE.txt) & [Commercial License](http://restya.com/contact))

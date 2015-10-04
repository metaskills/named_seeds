
# Always keep a CHANGELOG. See: http://keepachangelog.com

## v2.1.0 - 2015-10-04

* Support Rails 5 edge.


## v2.0.1 - 2015-03-29

* Added: `custom_seed_file` config. Use this to set a file other than `db/seeds.rb` for loading.
* Added: `load_app_seed_file` config which defaults to true. Use to disable `db/seeds.rb` when calling `NamedSeeds.load_seed`, typically for test env.


## v2.0.0 - 2015-03-25

* New version tested for Rails v4.0 to v4.2.


## v1.1.0 - 2014-11-27

* Many changes to support new Rails 4.2 sync test schema strategy.
* The test:prepare Task Might Be Useless Now? - http://git.io/mu2F2Q
* Bring back db:test:prepare - http://git.io/VKEwhg


## v1.0.4

* Make db:development:seed automatic based on Rails db:setup convention.


## v1.0.3

* Slacker rails dep version. 3.1 or up.


## v1.0.2

* Added a db:development:seed rake task.
* Update docs a bit more.


## v1.0.1

* Do nothing unless there is a seed file.


## v1.0.0 - 2012-03-26

Initial release

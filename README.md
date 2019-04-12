# README

As I am dealing with a important numbers of rows I chose to use the gem `activerecord-import`. 
My aim using it was to reduce the number of insert commands to the database which are costly in times.
In our example, there are 2 inserts for people.csv and 5 inserts for building.csv.

To set-up the repo:
* `bundle install`
* `rails db:create db:migrate`

I made a seed for people and buildings with 10_000 of rows each, you can launch them with the commands:

* `ruby app/services/csv_seeder/seed_building.rb`
* `ruby app/services/csv_seeder/seed_people.rb`

It also works with several of hundreds of thousands of rows (well, if your computer can handle it at least). But there's a possibility to chose the size of the batches with the gem (https://github.com/zdennis/activerecord-import/#batching).

To imports you have to do:

* `rails c`
* `Importer.import_from_csv(['manager_name'], 'db/building.csv', Building)`
* `Importer.import_from_csv(['email', 'home_phone_number', 'mobile_phone_number', 'address'], 'db/people.csv', Person)`

I made unit tests with Rspec for the models and the Importer (I didn't test the seeder as it wasn't part of the feature), you can launch them with:

* `rspec`

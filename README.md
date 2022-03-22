# TWG Client Data Tool

## Purpose

This tool allows you to parse csv and psv customer/vehicle data files and save their contents to a PostgresQL database.
The contents of each row of data will create a `Customer` and an associate `Vehicle`. There is de-duping logic so that if a
customer or vehicle already exists, it will not be created. `Customers` can be sorted based on their full name or their vehicle
type. There is also an option to return `Customers` with all of their relevant data (ie. personal and vehicle data.)

## Project Initialization

This is a Ruby (2.7.1) on Rails (6.0.4.7) application with a PostgresQL database and an RSpec test suite. To initialize the
project:

1. Start a local [PostgresQL](https://www.postgresql.org/docs/) server
2. $ git clone git@github.com:markevan100/outdoorsy.git
3. $ cd outdoorsy
4. $ bundle install
5. $ rails db:create
6. $ rails db:migrate
7. $ rails c

## Project Usage

The first thing I recommend doing is loading some data into the tool. In the `spec/file_fixtures/` folder, I have added
the provided data files along with two others to help with more robust testing. You can parse any of these files you like
or create your own. To parse one of the provided files, use the `ClientDataParser` class and its `parse` method, providing the file
file path as an argument.
For example: `ClientDataParser.parse('spec/file_fixtures/pipes.txt')`

You must load files one by one, but you can do this as many times as you would like. Duplicate data will be removed.

Once you have loaded data, you can see customers and vehicles using standard ActiveRecord commands. For example, `Customer.all`,
`Vehicle.all`, `Customer.first`, `Customer.first.vehicles`, etc.

Note that there is a one to many relationship between a Customer and their Vehicles.

There are also three custom sorting/data scopes provided on the Customer class. You can:
1. Sort all Customers by full name: `Customer.by_full_name`
2. Sort all Customers by vehicle type: `Customer.by_vehicle_type`
3. Sort all Customers by vehicle type in descending order: `Customer.by_vehicle_type('desc')`
4. See all data for all Customers: `Customer.all_data`

## Testing

This project is tested with RSpec with added Shoulda-Matchers. The models, scopes, and parser are tested. You can run
the test suite from the Rails console with the command `rspec`. You can run an individual file by providing the file
path as an argument to that command. Additional files in have been added to the test data (under `spec/file_fixtures`)
to more robustly test the models and parser. For example, these include duplicate customers with different vehicles,
different users with the same first name (to test full_name sorting), etc.

## Design Decisions

### Data Parsing

For data parsing, I have opted to go with an `IO.foreach` method to parse the files. I wanted to make sure to avoid
'slurping' file data, as file size may increase in the future. By running files line by line we create a more efficient
stream process than loading a large file into memory all at once.

Because we want to handle both pipe delineated and comma delineated data, a `col_sep` is passed to the `CSV.parse` method.
The variable for that `col_sep` is instantiated outside of the iterator and memoized such that the `include?` method will
only run once per file and not slow down a large file.

Because the original files have no headers, I am passing in custom headers to the parser. Passing in headers creates a hash
as opposed to an array, giving us better reference consistency with our data (always prefer not to depend too often on the
indexing of an array.)

Vehicle length needs to be standardized by stripping units. Currently, I am doing that with `.to_f` which works for all
provided examples. If we were to have data such as `feet: 30` in that space, the `.to_f` would no longer work, so we could
consider upgrading to use REGEX to identify digits or something similar, but at the moment this seemed sufficient.

Vehicle type (called `category` in the database because type is a reserved word) is also sanitized with down-casing. Ruby
sort methods treat capitalized letters differently, and we don't want `EV` to come before `bicycle`, for example.

In order to avoiding duplicating data, I have chosen the `find_or_create_by` method. I create both objects separately, as that
seemed the cleanest in this situation (both for avoiding duplication and to make it explicit to another developer reading this
file exactly what is going on.) We could have set up the `Customer` class to accept nested attributes for its vehicles, and
that might be a change we opt for in the future.

### Customer Model

One obvious place for more or less building here is in the validations. I have validated that everything is present, but more
could be done depending on business needs or how we foresee data coming in. Email is certainly a place where I would likely
build in more validation, maybe with a uniqueness constraint on the database, uniqueness validator on the model, and creating
a specific email formatting validator.

For sorting, I considered creating a catch-all method that would accept an attribute to be sorted by and a direction.
Given what was requested, I decided that the individual scopes were likely sufficient at this point, but if the business
were to decide in the future they wanted more sorting ability, we could add more scopes and have them called through a wrapper
method that would accept any of those attributes and call the relevant scope.

One improvement that could be on the horizon is dictating how objects that match are sorted. For example, when two customers
have a vehicle of type `sailboat`. Currently, those would be returned in their original database sequence.

I left `full_name` as a virtual attribute on the `Customer` model. In my experience, names can be challenging to parse. For
example, if I try to parse full name on a whitespace to get first and last, but the user has multiple whitespaces in their
name, my parser will not work. Easiest to start out saving first and last name separately, and then combine them
when needed. I was happy to see that whoever set up these data files felt the same way.

## Conclusion

Thank you so much for this fun project! Please let me know if you have any questions, markevan1002gmail.com. I look forward to
chatting about the project, about the design decisions, and about was that this can be improved.

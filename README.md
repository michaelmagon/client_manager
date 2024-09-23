# Client Manager

Manage a client list by Search and detecting duplicates from a JSON list

## Requirements
- Ruby (version 2.5 or higher)

## Usage

`--file FILE`: Specify the JSON file containing client data.

`--search query`: Search value for clients. When no query key is passed, it searches for a math from the client's Full Name. Can pass multiple seach queries to search for multiple clients.

`--duplicates`: Check for duplicate email addresses in the dataset.

`--query-key KEY`: Key to match the query value with. Defaults to `full_name`. Only works with search command

Commands can be combined to perform multiple operations at once.

### Example
```shell
ruby app.rb --file clients.json --search "John"

ruby app.rb --file clients.json --search "John" --query-key "email"

ruby app.rb --file clients.json --duplicates
```

## Running the tests
Make sure you have the `rspec` gem installed. If not, run `bundle install`.

```shell
rspec
```

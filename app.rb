require 'optparse'
require_relative 'client_manager'

options = {
  search_queries: [],
  duplicates: false
}

OptionParser.new do |opts|
  opts.banner = "Usage: app.rb [options]"

  opts.on("-f", "--file FILE", "JSON file with client data") do |file|
    options[:file] = file
  end

  opts.on("-q", "--query-key KEY", "Key to match the search query against, defaults to full_name") do |key|
    options[:query_key] = key
  end

  opts.on("-s", "--search NAME", "Search query") do |name|
    options[:search_queries] << name
  end

  opts.on("-d", "--duplicates", "Find clients with duplicate emails") do
    options[:duplicates] = true
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

unless options[:file]
  puts "Error: JSON file must be specified using the --file option."
  exit
end

manager = ClientManager.new(options[:file])

if options[:search_queries]
  options[:search_queries].each do |query|
    puts "\nSearching for clients matching '#{query}':"
    manager.search(query, options[:query_key])
  end
end

if options[:duplicates]
  puts "\nChecking for duplicate emails:"
  manager.duplicates
end

if options[:search_queries].empty? && !options[:duplicates]
  puts "Error: You must specify at least one command (e.g., --search or --duplicates)."
end

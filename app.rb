require 'optparse'
require_relative 'client_manager'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: app.rb [options]"

  opts.on("-f", "--file FILE", "JSON file with client data") do |file|
    options[:file] = file
  end

  opts.on("-q", "--query-key KEY", "Key to match the search query against, defaults to full_name") do |key|
    options[:query_key] = key
  end

  opts.on("-s", "--search NAME", "Search query") do |name|
    options[:command] = :search
    options[:query] = name
  end

  opts.on("-d", "--duplicates", "Find clients with duplicate emails") do
    options[:command] = :duplicates
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

case options[:command]
when :search
  if options[:query].nil?
    puts "Error: You must provide a value to search."
    exit
  end
  manager.search(options[:query], options[:query_key])
when :duplicates
  manager.duplicates
else
  puts "Error: Specify a command (e.g., --search or --duplicates)."
end

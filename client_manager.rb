require 'json'

class ClientManager
  attr_reader :clients

  def initialize(json_file)
    @clients = load_clients(json_file)
  end

  def load_clients(json_file)
    file = JSON.parse(File.read(json_file))
  rescue JSON::ParserError
    puts "Invalid JSON file."
    exit
  end

  def search(query, query_key = 'full_name')
    results = clients.select do |client|
      client[query_key.downcase].to_s.downcase.include?(query.downcase)
    end

    if results.empty?
      puts "No clients found with #{query_key} containing '#{query}'."
    else
      puts "Clients with #{query_key} #{query} found:"
      results.each { |client| puts "- #{client['full_name']} (#{client['email']})" }
    end
  end

  def duplicates
    if duplicate_emails.empty?
      puts "No duplicate emails found."
    else
      puts "Duplicate emails found:"
      duplicate_emails.each do |email, clients_with_same_emails|
        puts "- Email: #{email}"
        clients_with_same_emails.each { |client| puts "  - #{client['full_name']}" }
      end
    end
  end

  private

  def duplicate_emails
    @duplicate_emails ||= clients.group_by { |client| client['email'] }.select { |_k, v| v.size > 1 }
  end
end

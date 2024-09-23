require_relative '../client_manager'


RSpec.describe ClientManager do
  subject { described_class.new(json_file) }
  let(:json_file) { 'spec/fixtures/clients.json' }

  describe 'load_clients' do
    it 'loads the clients from the JSON file' do
      expect(subject.clients.size).to eq(15)
      expect(subject.clients.first['full_name']).to eq('John Doe')
      expect(subject.clients.last['full_name']).to eq('Another Jane Smith')
    end
  end

  describe 'search' do
    context 'when query is john' do
      let(:query) { 'john' }
      it 'finds clients by full name' do
        expect { subject.search(query) }.to output(/John Doe \(john.doe@gmail.com\)/).to_stdout
        expect { subject.search(query) }.to output(/Alex Johnson \(alex.johnson@hotmail.com\)/).to_stdout
      end

      context 'when query key is email' do
        let(:query_key) { 'email' }
        it 'finds clients by email' do
          expect { subject.search(query, query_key) }.to output(/John Doe \(john.doe@gmail.com\)/).to_stdout
          expect { subject.search(query) }.to output(/Alex Johnson \(alex.johnson@hotmail.com\)/).to_stdout
        end
      end
    end

    context 'when query is ava' do
      let(:query) { 'ava' }
      it 'finds clients by full name' do
        expect { subject.search(query) }.to output(/Ava Taylor \(ava.taylor@mail.com\)/).to_stdout
      end
    end

    context 'when query is yahoo' do
      let(:query) { 'yahoo' }
      it 'finds clients by email' do
        expect { subject.search(query) }.to output(/No clients found with full_name containing 'yahoo'./).to_stdout
      end

      context 'when query key is email' do
        let(:query_key) { 'email' }
        it 'finds clients by email' do
          expect { subject.search(query, query_key) }.to output(/Jane Smith \(jane.smith@yahoo.com\)/).to_stdout
          expect { subject.search(query, query_key) }.to output(/Another Jane Smith \(jane.smith@yahoo.com\)/).to_stdout
        end
      end
    end
  end

  describe 'find_duplicates' do
    it 'finds clients with duplicate emails' do
      expect { subject.duplicates }.to output(/Jane Smith/).to_stdout
      expect { subject.duplicates }.to output(/Another Jane Smith/).to_stdout
    end
  end
end

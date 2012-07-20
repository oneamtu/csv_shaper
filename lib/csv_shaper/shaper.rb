module CsvShaper
  class Shaper < BlankSlate
    def initialize
      @rows = []
    end
    
    # Public: creates a new instance of Shaper taps it with
    # with the given block and encodes it to a String of CSV data
    # Example:
    #   data = CsvShaper::Shaper.encode do |csv|
    #     csv.rows
    #   end
    #
    #  puts data
    #  => "Name,Age,Gender\n'Joe Bloggs',25,'M'\n'John Smith',34,'M'" 
    #
    # Returns a String
    def self.encode
      new.tap { |shaper| yield shaper }.encode!
    end
    
    # Public: creates a header row for the CSV
    # This is delegated to the Header class
    # see header.rb for usage examples
    #
    # Returns a Header instance
    def headers(*args, &block)
      @head = Header.new(*args, &block)
    end
    
    # Public: adds a row to the CSV
    # This is delegated to the Row class
    # See row.rb for usage examples
    #
    # Returns an updated Array of Row objects
    def row(*args, &block)
      @rows.push Row.new(*args, &block)
    end
    
    # Public: adds several rows to the CSV
    #
    #   collection - an Enumerable of objects to be passed to #row
    #
    # Returns an updated Array of Row objects
    def rows(collection, &block)
      unless collection.respond_to?(:each)
        raise ArgumentError, 'csv.rows only accepts Enumerable object (that respond to #each). Use csv.row for a single object.'
      end
      
      collection.each do |element|
        row(element, &block)
      end
      
      @rows
    end
    
    # Public: converts the Header and Row objects into a string
    # of valid CSV data. Delegated to the Encoder class
    #
    # Returns a String
    def encode!
      Encoder.new(@head, @rows)
    end
  end
end

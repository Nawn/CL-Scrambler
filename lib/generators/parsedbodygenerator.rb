module BodyGenContainer
  class ParsedBody

    def initialize
      @search = "seeds/body_seeds/*.txt"
    end

    def return_body
      # Get a template will pick a .txt template at random
      file_name = get_a_template

      # Read the file, with some error handling for missing files
      begin
        text = File.read(file_name)

        # Parse the file, make sure to replace all #[~] with one choice.
        Parser.parse(text)
      rescue TypeError => @e
        return "ERROR! No .txt files located in #{@search}, error msg: #{@e}"
      rescue ArgumentError => @a
        return "ERROR: #{@a},\nfile_name: #{file_name}"
      end

      # Return the final text, after it's been parsed
      return text
    end

    private
    # Pick a random file from the seeds directory
    def get_a_template
      Dir[@search].sample
    end
  end
end
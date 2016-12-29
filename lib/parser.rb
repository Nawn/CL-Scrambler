class Parser
  def self.parse(input_text)
    # Parse index will be the location of the '#[' string
    
    parse_index = 0

    while (parse_index)
      # Grab the first opening bracket
      parse_index = input_text.index("#[", parse_index)

      # Then begin parsing if there is one, and continue until there is none
      self.parse_text(input_text, parse_index) if parse_index
    end

    return input_text
  end

  private
  def self.parse_text(input_text, input_index)
    # Find the ending point
    end_parse_index = input_text.index("]", input_index)

    raise ArgumentError.new("No ending bracket for beginning index: #{input_index}, context: #{input_text[input_index..input_index+200]}") unless end_parse_index
    # Search for an opening tag between the start and end
    # If there is none, it will return nil(falsey), so in that case, I will set it 
    # to a value that is not between them (ending value + 1)
    # Also, the reason I selected input_index+1, is because if I don't modify
    # input_index, it'll simply return the input_index
    temp_index = input_text.index("#[", input_index+1) || end_parse_index + 1


    # If the temp_index is between the beginning and end
    if temp_index > input_index && temp_index < end_parse_index
      # Parse the nested first 
      parse_text(input_text, temp_index)

      # Then try to parse yourself again afterwords
      parse_text(input_text, input_index)
    else # Base case: 

      # base case: get the options example: "one~two~three"
      parsing_text = input_text[input_index+2..end_parse_index-1]

      # Replace the #[] with one of the options
      input_text[input_index..end_parse_index] = parsing_text.split("~").sample
    end
  end
end
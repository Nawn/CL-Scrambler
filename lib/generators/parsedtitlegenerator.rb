module TitleGenContainer
  class ParsedTitle
    def initialize()
      @seed_file = "./seeds/title_seeds/title_seeds.txt"
    end

    def return_title
      # Grabs a random line from the file, and parses it
      Parser.parse(File.readlines(@seed_file).sample)
    end
  end
end
require "ffi"
require "clipboard"
require_relative "parser.rb"

# Grab all the files from the generators folder, and include them
Dir["lib/generators/*.rb"].each do |require_file|
	require "./#{require_file}"
end

class Scrambler
	# Empty initialize.
	def initialize
	end

	# This is the overhead, generate the entire thing, based on Symbol input
	def scramble(input = "--title")

		user_input = input.downcase

		case user_input
		when "--title"
			make_title
		when "--body"
			make_body
		when "--image"
			choose_image
		else
			incorrect_input
		end
	end

	private

	# Simply to let the user know that ARGV[0] was invalid
	def incorrect_input
		Clipboard.copy("Argument must be --title, --body, or --image")
	end

	# Generate the title, and Copy it
	def make_title
		Clipboard.copy(gen_title)
	end

	# Generate the body, and Copy it
	def make_body
		Clipboard.copy(gen_body)
	end

	# It'll select from local directory
	def choose_image
		# The reason I gsub the / to a \, is because of the Windows FileSystem. / give errors
		# while \ do not. /shrug
		image = Dir["seeds/images/*.png"].sample

		unless image.nil?
			Clipboard.copy((Dir.pwd + "/" + image).gsub("/", "\\")) 
		else
			Clipboard.copy("No acceptable images")
		end
	end


	def gen_title
		# This will create a maker of a random class, all held within the container/module for TitleGenerator classes
		maker = TitleGenContainer.const_get(TitleGenContainer.constants.sample).new

		# All objects within those classes have a return_title method.
		maker.return_title
	end

	def gen_body

		# 25% chance to run the corporate body, else to run the template bodies
		# if ((rand() * 100) + 1) < 25
		# 	maker = BodyGenContainer::CorporateBody.new
		# else
		# 	maker = BodyGenContainer::ParsedBody.new
		# end

		# This will create a maker of a random class, all held within the body generator container,
		maker = BodyGenContainer.const_get(BodyGenContainer.constants.sample).new

		maker.return_body
	end
end
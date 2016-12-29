require_relative "lib/scrambler.rb"

scram = Scrambler.new

begin
	scram.scramble(ARGV[0])
rescue ArgumentError => e
	puts "#{e}"
end
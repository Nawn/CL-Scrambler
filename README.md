# CL Scrambler
## Intended Use

I built this program to go along with facilitating my Craigslist postings. It is a program that works alongside my CL Posting macro. Essentially, my macro (built using [Pulover's Macro Creator](http://www.macrocreator.com/)) will navigate the Craigslist user interface to arrive to the post creation form. It will then run my script, with the appropriate argument (--body, --image, or --title) so that it knows what to grab. Whichever it is, it will yield a response, and copy it directly onto my clipboard, so that my macro can then simply Paste into the appropriate field. 

Because of the fact that Craigslist does not like bots, I had to make sure that the output was not always the same, and in fact, as human as possible. But how do I achieve that, without hand-writing the posts I make? Well, I don't. I do hand write the posts, however I include plenty of synonyms and run the text file through my Parser.parse function, which is an algorithm that will replace all #[~] notation with one of the options separated by the `~`. The `#[` string will trigger the parsing. It will look for the appropriate `]`, and then pick one of the strings separated by the `~`. 

**Also, _YES_, you _can_ nest your #[~] statements.**

## Parser Example~!

Save a *.txt file in the seeds/body_seeds/ directory with the content: 

`Hello, this is #[an example~a test~#[for~from] #[demonstration~Sparta!~testing purposes]]`

The next time you run `ruby scramble.rb --body`, it will take this file into consideration, and if it picks this file, it will parse out all of the #[~] syntax. These are the potential outcomes:

* `Hello, this is an example`
* `Hello, this is a test`
* `Hello, this is for demonstration`
* `Hello, this is from demonstration`
* `Hello, this is for Sparta!`
* `Hello, this is from Sparta!`
* `etc.` 

*Note: You can use #[~] in the default Title and Body generators.*

## Dependancies

* `gem install ffi`
* `gem install clipboard`

## Folder Structure:

	Scramble
		- lib
			- generators
				- parsedbodygenerator.rb
				- parsedtitlegenerator.rb
			- scrambler.rb (Entry Class)
			- parser.rb (Parse #[~] notation)
		- seeds
			- images (accepts .png only by default)
			- title_seeds (storage of title_seeds.txt seeds)
			- body_seeds (storage of template *.txt files)

		scramble.rb (Start point. ruby scramble.rb --<argument>)

## Usage:
1. navigate to the directory
2. run `ruby scramble.rb ` with the argument of your choosing (example: `ruby scramble.rb --body`)
3. the result will be copied onto your clipboard.

## Arguments

### **--title**: 

	Title will grab a random class from TitleGenContainer module and run #return_title on the object (#return_title must return a string.)

	The only class I have included in TitleGenContainer is my default ParsedTitle. Which takes a random line from seeds/title_seeds/title_seeds.txt 
	(ignoring all other files/folders), parses it for any #[~], and then copies the result to your clipboard (Ctrl + V to paste)
    
    If you would like to add your own custom title generation logic, simply add your class to the TitleGenContainer module and it'll have a chance of being called upon. Make sure that you have a method called return_title, and it returns a string. Place that *.rb file in lib/generators. If you need to parse out some #[~] notation, you can use Parser.parse(input_string).

### **--image**:

	This one is fairly simple. It will check the directory seeds/images/ and look for any PNGs, then copy the full filepath of the image to clipboard.
	If you'd like to modify this code, you can do so in lib/scrambler.rb:#choose_image

### **--body**:

	Body will grab a random class from BodyGenContainer module and run #return_body on the object.
	(#return_body must return a string.)

	The only class I have included in BodyGenContainer is my default ParsedBody. Which takes a random *.txt file from seeds/body_seeds/. It will not 
	recurse into other directories, so if you wish for this class to ignore a *.txt file, simply store that txt file in a folder. (This should
	allow for organization of your own custom classes.). Once it has pulled the content of the random *.txt file, it parses and then copies to your clipboard (Ctrl + V to paste)
    
    If you would like to use your own Body generation logic, simply add your class to the BodyGenContainer module and it'll have a chance of being called upon. Make sure that you have a method called #return_body, and it returns a string. Place that *.rb file in lib/generators. If you need to parse out some #[~] notation, you can use Parser.parse(input_string).

### Notice

This software was written and tested in Windows. Cannot guarentee it will work on other platforms without tweaking

### Tips
You can change percentage change with some very simple ruby code in `lib/scrambler.rb`

I have added some example files. Make sure to delete them once you get the hang of things

Example: 
```ruby

	def gen_body

		# 25% chance to run the corporate body, else to run my default class
		if ((rand() * 100) + 1) < 25
			maker = BodyGenContainer::CorporateBody.new 
            # In this case, you wrote the CorporateBody class, in the BodyGenContainer module,
            # and placed the .rb file in lib/generators/
		else
			maker = BodyGenContainer::ParsedBody.new
		end
		
        # This is the default choice, it'll just pick randomly amount all classes
        # in the BodyGenContainer module
		# maker = BodyGenContainer.const_get(BodyGenContainer.constants.sample).new

		maker.return_body
	end
```
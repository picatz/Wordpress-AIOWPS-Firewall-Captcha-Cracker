# AIOWPS Captcha Cracker

AIOWPS ( All In One Wordpress Security & Firewall ) Captcha Cracker is a simple ruby script to act as a proof of concept that word mapping twenty numbers and base64 encoding the answer into the login page html is a bad idea.

TODO: 
* Add more options ( optparse ).
* Smarter url handeling.
* Write license?

## Installation
You're going to need to install the following ruby gems:                                                                     
`gem install nokogiri`

## Usage
`ruby aiowps-captcha-cracker.rb http://www.target-url.com/wp-login.php`

### Credits
Kent 'picat' Gruber

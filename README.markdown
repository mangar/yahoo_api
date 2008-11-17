# YahooApi

**YahooApi** is a library written on Ruby to be used on RoR application to get access to Yahoo! APIs.

## BOSS

Yahoo! Search BOSS (Build your Own Search Service) is an initiative in Yahoo! Search to open up Yahoo!'s search 
infrastructure and enable third parties to build revolutionary search products leveraging their own data, content, 
technology, social graph, or other assets. This release includes Web, News, and Image Search as well as Spelling Suggestions.

	require 'yahoo_api'
	#.
	#.
	def do_search

		# result will be setted on <res> var and the header (if necessary) will be returned on <header>
		res, header = BossApi.search({:key => "dicionário"})  

	    puts "Records found ...............: #{res.size}"
	    puts "#{header.each_pair { |k,v| puts "#{k} - #{v}" }}"
	end


## Installing

As plugin:

    ruby script/plugin install git://github.com/mangar/yahoo_api.git



## Help

Check the tests for more samples.

Enjoy!


Copyright (c) 2008 Marcio Garcia, released under the MIT license

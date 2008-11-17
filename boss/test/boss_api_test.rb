require 'test/unit'

require '../lib/boss_api'


class BossApiTest < Test::Unit::TestCase
  
  def test_url

    #usage: simple
    res, header = BossApi.search({:key => "dicionário"})  
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (1)")
    
    #usage site (:site)
    res, header =  BossApi.search({:key => "dicionário", :site => "www.uol.com.br"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (2)")

    #usage -site (:_site)
    res, header =  BossApi.search({:key => "dicionário", :_site => "www.uol.com.br"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20-site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (3)")    
        
    #usage minus (:-)
    res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :- => "-folha"})    
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20-folha%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (4)")

    #usage double minus (:-)
    res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :- => "-folha -abril -terra -globo"})    
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20-folha%20-abril%20-terra%20-globo%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (5)")

    #usage plus (:+)
    res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :+ => "+folha +terra"})    
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20+folha%20+terra%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (6)")

    #usage double plus (:+)
    res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :+ => "+Aurélio +abril"})    
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20+Aur%C3%A9lio%20+abril%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml", header[:url], "URL not expected for this search (7)")

    #usage count (:count)
    res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :count => "50"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/dicion%C3%A1rio%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&count=50", header[:url], "URL not expected for this search (8)")

    #usage start (:start)
    res, header = BossApi.search({:key => "link", :site => "www.uol.com.br", :count => "10", :start => "11"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/link%20site:www.uol.com.br?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&count=10&start=11", header[:url], "URL not expected for this search (9)")
    
    #region and language
    res, header = BossApi.search({:key => "Obama", :region => "Brazil"})        
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/Obama?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&region=br&lang=pt", header[:url], "URL not expected for this search (10)")
    
    res, header = BossApi.search({:key => "Obama", :region => "Argentina"})            
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/Obama?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&region=ar&lang=es", header[:url], "URL not expected for this search (11)")

    
    #web.filter
    res, header = BossApi.search({:key => "Pamela", :filter => "-porn"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/Pamela?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&filter=-porn", header[:url], "URL not expected for this search (12)")
    
    #web.type
    res, header = BossApi.search({:key => "Pamela", :type => "msoffice,-xl,-msword"})
    assert_equal("http://boss.yahooapis.com/ysearch/web/v1/Pamela?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&type=msoffice,-xl,-msword", header[:url], "URL not expected for this search (13)")

    #image.filter
    res, header = BossApi.search({:key => "Pamela", :filter => "no", :dimensions => "wallpaper", :type_search => "image"})  
    assert_equal("http://boss.yahooapis.com/ysearch/images/v1/Pamela?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&filter=no&dimensions=wallpaper", header[:url], "URL not expected for this search (14)")
    
    #image.news
    res, header = BossApi.search({:key => "Pamela", :age => "1d", :type_search => "news"})  
    assert_equal("http://boss.yahooapis.com/ysearch/news/v1/Pamela?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&age=1d", header[:url], "URL not expected for this search (15)")    
    
    res, header = BossApi.search({:key => "Pamela", :age => "10d", :type_search => "news"})  
    assert_equal("http://boss.yahooapis.com/ysearch/news/v1/Pamela?appid=HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-&format=xml&age=10d", header[:url], "URL not expected for this search (16)")    

    
    # res, header = BossAPI.search_web_free("", "")

    # puts "registros retornados ...............: #{res.size}"
    # puts "#{header.each_pair { |k,v| puts "#{k} - #{v}" }}"
    
  end
end

require 'test/unit'

require '../lib/boss_api'

class BossApiTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin

    
    boss = BossApi.new
    
    #usage: simple
    # res = boss.search({:key => "dicionário"})  

    
    #usage site (:site)
    # res, header =  BossApi.search({:key => "dicionário", :site => "www.uol.com.br"})

    #usage -site (:_site)
    # res, header =  BossApi.search({:key => "dicionário", :_site => "www.uol.com.br"})
    
    #usage minus (:-)
    # res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :- => "-folha"})    

    #usage double minus (:-)
    # res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :- => "-folha -abril -terra -globo"})    

    #usage plus (:+)
    # res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :+ => "+folha +terra"})    

    #usage double plus (:+)
    # res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :+ => "+Aurélio +abril"})    

    #usage count (:count)
    # res, header = BossApi.search({:key => "dicionário", :site => "www.uol.com.br", :count => "50"})

    #usage start (:start)
    # res, header = BossApi.search({:key => "link", :site => "www.uol.com.br", :count => "10", :start => "11"})


    #region and language
    res, header = boss.search({:key => "Obama", :region => "Brasil"})        
    
    #filter
    
    #type
    
    
    
    
    
    # boss.search({:key => "Marcio Garcia", :site => "github.com"}) 
    # , :site => "www.uol.com.br", :- => "folha", :+ => "Aurélio"})

    puts "registros retornados ...............: #{res.size}"
    puts "#{header.each_pair { |k,v| puts "#{k} - #{v}" }}"
    
    assert_equal("a", "a", "ok!")
  end
end

class BossApi

  require 'net/http'
  require 'rexml/document'

  # Your Boss AppId 
  AppID = "HaxX0zXIkY0UnUsuwIWe83UMaSkbqbU2Y4mlSi4-"

  # Boss URL base
  BOSS_URL_WEB = "http://boss.yahooapis.com/ysearch/web/v1/"
  BOSS_URL_IMAGES = "http://boss.yahooapis.com/ysearch/images/v1/"
  BOSS_URL_NEWS = "http://boss.yahooapis.com/ysearch/news/v1/"
  
  
  # Default response format (xml / json)
  # Can be replaced via parameter
  Format_Default = "xml"

  # Default Region and Language
  # Can be replaced via parameter  
  RegionLanguage_Default = "Brazil"


  #
  # Correios class can be initialized using a pre defined config file as parameter
  # if no one is specified, will be used the default: /../config/correios.yml
  #
  def initialize
    @config = YAML.load_file(File.dirname(__FILE__) + "./boss.yaml")
  end

  # Allowed parameters:
  #
  # WEB arguments: filter, type
  # Images arguments: filter, dimensions, refererurl, url
  # News arguments: age
  #
  # Universal arguments: http://developer.yahoo.com/search/boss/boss_guide/univer_api_args.html
  #  - start, count, lang, region, format, callback, sites
  #
  # Response sample (web): http://developer.yahoo.com/search/boss/boss_guide/example_xml_out.html
  #  - fields description: http://developer.yahoo.com/search/boss/boss_guide/response_fields.html#recommended_region
  #  - optional arguments: http://developer.yahoo.com/search/boss/boss_guide/Web_Search.html#optional_args_web
  #
  # Response sample (image): http://developer.yahoo.com/search/boss/boss_guide/response_image.html#xml_out_image
  #  - fields description: http://developer.yahoo.com/search/boss/boss_guide/response_image.html
  #  - optional arguments: http://developer.yahoo.com/search/boss/boss_guide/Submit_Image_Queries.html#optional_args_image
  #
  # Response sample (news): http://developer.yahoo.com/search/boss/boss_guide/response_news.html#xml_out_news
  #  - fields description: http://developer.yahoo.com/search/boss/boss_guide/response_news.html
  #  - optional arguments: http://developer.yahoo.com/search/boss/boss_guide/News_Search.html#optional_args_news
  #
  #
  def search(par = {})

    #key...
    url = "#{BOSS_URL}#{URI.escape(par[:key])}"
    
    #... -
    url += URI.escape(" #{par[:-]}") if (par.key? :-)

    #... +
    url += URI.escape(" #{par[:+]}") if (par.key? :+)
    
    #... site
    url += URI.escape(" site:#{par[:site]}") if (par.key? :site)
    
    #... -site
    url += URI.escape(" -site:#{par[:_site]}") if (par.key? :_site)

    
    #...appid and format
    url += "?appid=#{AppID}"
    
    #... format
    url += "&format=#{Format_Default}"
    
    #... count ==> Total number of results to return. Maximum value is 50. Default sets count to 10.
    url += URI.escape("&count=#{par[:count]}") if (par.key? :count)
    
    #... start ==> Ordinal position of first result. First position is 0. Default sets start to 0.
    url += URI.escape("&start=#{par[:start]}") if (par.key? :start)


        
    #... region and language
    url += URI.escape(@config['Argentina']) if (par.key? :region)    
    
    
    
    # parameters for web.................
    # filter
    # type
      # You can combine inclusion, exclusion, document types, and type groups like this:
      # type=html,msoffice,-pdf
    
    
    
    # parameters for images..............
    # filter
    # dimensions
    # refererurl
    # url
    

    # parameters for news................
    # age

    

    
    
    # puts "URL: #{url}"
    data = Net::HTTP.get_response(URI.parse(url)).body
    # puts "Data: \n\n #{data}"
    
    doc = REXML::Document.new(data)

    # header...
    header = Hash.new
    header[:url] = url
    header[:responsecode] = doc.root.attributes["responsecode"]
    header[:prevpage] = doc.root.elements["prevpage"].text if (doc.root.elements["prevpage"] != nil)
    header[:nextpage] = doc.root.elements["nextpage"].text if (doc.root.elements["nextpage"] != nil)
    header[:count] = doc.root.elements["resultset_web"].attributes["count"]
    header[:start] =  doc.root.elements["resultset_web"].attributes["start"]
    header[:totalhits] =  doc.root.elements["resultset_web"].attributes["totalhits"]
    header[:deephits] =  doc.root.elements["resultset_web"].attributes["deephits"]

    # data...
    records = Array.new
    doc.root.each_element('//ysearchresponse/resultset_web/result') do |result| 
      record = {}      
      result.each_element do |ele|
        record.merge!({ele.name => ele.text})
      end
      records << record
    end

    return records, header
  end



  # RegionLanguage = new Hash[]
  # RegionLanguage[:Canada - English] = "&region=ca&lang=en"
  # RegionLanguage[:Canada - French] = "&region=ca&lang=fr"
  # RegionLanguage[:Catalan] = "&region=ct&lang=ca"
  # RegionLanguage[:Chile] = "&region=cl&lang=es"
  # RegionLanguage[:Columbia] = "&region=co&lang=es"
  # RegionLanguage[:Denmark] = "&region=dk&lang=da"
  # RegionLanguage[:Finland] = "&region=fi&lang=fi"
  # RegionLanguage[:Indonesia - English] = "&region=id&lang=en"
  # RegionLanguage[:Indonesia - Indonesian] = "&region=id&lang=id"
  # RegionLanguage[:India] = "&region=in&lang=en"
  # RegionLanguage[:Japan] = "&region=jp&lang=jp"
  # RegionLanguage[:Korea] = "&region=kr&lang=kr"

  # Mexico
  # 
  # 
  # mx
  # 
  # 
  # es
  # 
  # Malaysia - English
  # 
  # 
  # my
  # 
  # 
  # en
  # 
  # Malaysia
  # 
  # 
  # my
  # 
  # 
  # ms
  # 
  # Netherlands
  # 
  # 
  # nl
  # 
  # 
  # nl
  # 
  # Norway
  # 
  # 
  # no
  # 
  # 
  # no
  # 
  # New Zealand
  # 
  # 
  # nz
  # 
  # 
  # en
  # Peru  pe  es
  # 
  # Philippines
  # 
  # 
  # ph
  # 
  # 
  # tl
  # Philippines - English   ph  en
  # 
  # Russia
  # 
  # 
  # ru
  # 
  # 
  # ru
  # 
  # Sweden
  # 
  # 
  # se
  # 
  # 
  # sv
  # 
  # Singapore
  # 
  # 
  # sg
  # 
  # 
  # en
  # 
  # Thailand
  # 
  # 
  # th
  # 
  # 
  # th
  # 
  # Switzerland - German
  # 
  # 
  # ch
  # 
  # 
  # de
  # 
  # Switzerland - French
  # 
  # 
  # ch
  # 
  # 
  # fr
  # 
  # Switzerland - Italian
  # 
  # 
  # ch
  # 
  # 
  # it
  # 
  # German
  # 
  # 
  # de
  # 
  # 
  # de
  # 
  # Spanish
  # 
  # 
  # es
  # 
  # 
  # es
  # 
  # French
  # 
  # 
  # fr
  # 
  # 
  # fr
  # 
  # Italian
  # 
  # 
  # it
  # 
  # 
  # it
  # 
  # United Kingdom
  # 
  # 
  # uk
  # 
  # 
  # en
  # 
  # United States - English
  # 
  # 
  # us
  # 
  # 
  # en
  # 
  # United States - Spanish
  # 
  # 
  # us
  # 
  # 
  # es
  # Vietnam   vn  vi
  # Venezuela   ve  es



end





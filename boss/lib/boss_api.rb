class BossApi

  require 'net/http'
  require 'rexml/document'
  require 'yaml'

  # Boss URL base
  BOSS_URL_WEB = "http://boss.yahooapis.com/ysearch/web/v1/"
  BOSS_URL_IMAGE = "http://boss.yahooapis.com/ysearch/images/v1/"
  BOSS_URL_NEWS = "http://boss.yahooapis.com/ysearch/news/v1/"
  
  
  # Default response format (xml / json)
  # Can be replaced via parameter
  Format_Default = "xml"

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
  def self.search(par = {})

    config = YAML.load_file(File.dirname(__FILE__) + "/boss_api.yaml")

    #key...
    url = "#{URI.escape(par[:key])}"
    
    #... -
    url += URI.escape(" #{par[:-]}") if (par.key? :-)

    #... +
    url += URI.escape(" #{par[:+]}") if (par.key? :+)
    
    #... site
    url += URI.escape(" site:#{par[:site]}") if (par.key? :site)
    
    #... -site
    url += URI.escape(" -site:#{par[:_site]}") if (par.key? :_site)

    #...appid and format
    url += "?appid=#{config['AppID']}"
    
    #... format
    url += "&format=#{Format_Default}"
    
    #... count ==> Total number of results to return. Maximum value is 50. Default sets count to 10.
    url += URI.escape("&count=#{par[:count]}") if (par.key? :count)
    
    #... start ==> Ordinal position of first result. First position is 0. Default sets start to 0.
    url += URI.escape("&start=#{par[:start]}") if (par.key? :start)

    #... region and language
    url += URI.escape("#{config[par[:region]]}") if (par.key? :region)    
    
    
    
    # parameters for web: filter, type
    if (!(par.key? :type_search) || (par[:type_search].eql? "web")) then
      
      url = "#{BOSS_URL_WEB}#{url}"
      
      #... filter
      url += URI.escape("&filter=#{par[:filter]}") if (par.key? :filter)
      
      #... type
      url += URI.escape("&type=#{par[:type]}") if (par.key? :type)      
    
    # parameters for images: filter, dimensions, refererurl, url
    elsif (par[:type_search].eql? "image") then
      
      url = "#{BOSS_URL_IMAGE}#{url}"
      
      #... filter
      url += URI.escape("&filter=#{par[:filter]}") if (par.key? :filter)      

      #... dimensions
      url += URI.escape("&dimensions=#{par[:dimensions]}") if (par.key? :dimensions)
      
      #... refererurl
      url += URI.escape("&refererurl=#{par[:refererurl]}") if (par.key? :refererurl)
      
      #... url
      url += URI.escape("&url=#{par[:url]}") if (par.key? :url)
                            
    # parameters for news: age
    elsif (par[:type_search].eql? "news") then
      
      url = "#{BOSS_URL_NEWS}#{url}"
      
      #... age
      url += URI.escape("&age=#{par[:age]}") if (par.key? :age)
      
    end

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
    
    
    if (!(par.key? :type_search) || (par[:type_search].eql? "web")) then
      header[:count] = doc.root.elements["resultset_web"].attributes["count"]
      header[:start] =  doc.root.elements["resultset_web"].attributes["start"]
      header[:totalhits] =  doc.root.elements["resultset_web"].attributes["totalhits"]
      header[:deephits] =  doc.root.elements["resultset_web"].attributes["deephits"]
      
    elsif (par[:type_search].eql? "image") then
      header[:count] = doc.root.elements["resultset_images"].attributes["count"]
      header[:start] =  doc.root.elements["resultset_images"].attributes["start"]
      header[:totalhits] =  doc.root.elements["resultset_images"].attributes["totalhits"]
      header[:deephits] =  doc.root.elements["resultset_images"].attributes["deephits"]      
      
    elsif (par[:type_search].eql? "news") then
      header[:count] = doc.root.elements["resultset_news"].attributes["count"]
      header[:start] =  doc.root.elements["resultset_news"].attributes["start"]
      header[:totalhits] =  doc.root.elements["resultset_news"].attributes["totalhits"]
      header[:deephits] =  doc.root.elements["resultset_news"].attributes["deephits"]
      
    end

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


end





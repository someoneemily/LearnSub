class UserMailer < ApplicationMailer
  default :from => 'from_zeroto_pro@example.com'

  def send_daily_email(user_email, interest)
  	@time = interest.time
  	@duration = ''
  	if @time <= 4
  		duration = 'short'
  	elsif @time >= 20
  		duration = 'long'
  	else
  		duration = 'medium'
  	end
    @allowedTime = @time
    query(interest.topics)
    # @data = `python3 untitled.py --q '"#{interest.topics}"' --duration '#{duration}'`
    # @data = @data.strip
    mail( :to => user_email,
    :subject => 'Your Daily List of Enlightenment')
  end
  def query(q)
    keyword = q
    # keyword = "Math"
    # keyword = 'Test'
    begin
      url = URI.encode("https://en.wikipedia.org/w/api.php?action=parse&format=json&page=" + keyword)

      js = JSON.parse(HTTParty.get(url).body)
      html_doc = Nokogiri::HTML(js['parse']['text']["*"])
    rescue
      @error = true
      return
    end
    # puts js["parse"]['text']["*"]
    res = html_doc.xpath('//div[@class="hatnote navigation-not-searchable"]//a')
    if res.length == 0
      # puts "HI"
      res = html_doc.xpath('//div[@class="redirectMsg"]')
      keyword =  res.text.split(":")[1]
      url = URI.encode("https://en.wikipedia.org/w/api.php?action=parse&format=json&page=" + keyword)
      data = HTTParty.get(url).body
      js = JSON.parse(data)
      # puts js["parse"]['text']["*"]
      html_doc = Nokogiri::HTML(js['parse']['text']["*"])
      res = html_doc.xpath('//div[@class="hatnote navigation-not-searchable"]//a')
    end
    if res.length == 0
      res = [keyword]
    else
      res = [res.to_a.shuffle[0]]
    end
    @links = []

    for r in res
      query = r.text
      if query["("]
        query = query.split("(")[0]
      end
      puts query
      if @time <= 4
    		duration = 'short'
    	elsif @time >= 20
    		duration = 'long'
    	else
    		duration = 'medium'
    	end
      @data = `python3 untitled.py --q "#{query}" --duration '#{duration}'`
      @data = @data.strip.split("\n")
      @links = []
      for d in @data
        @links.push([d.split(",")[1],d.split(",")[0],d.split(",")[2]])
        # @allowedTime -= d.split(",")[2].to_i
      end
      url = URI.encode("https://www.googleapis.com/customsearch/v1?key=AIzaSyAEmsXCj7MOG1VilIbR2LrdWhprl_adtwI&cx=002125709754234605584:y65djfilez0&q=#{query}")
      js = JSON.parse(HTTParty.get(url).body)
      for item in js["items"]
        # @links.push(item["link"])
        html_doc = Nokogiri::HTML(HTTParty.get(item["link"]).body)
        res = html_doc.xpath('//span[@class="readingTime"]')
        if res.length != 0
          @links.push([item["title"],item["link"],res.attr('title').text.split(" min")[0]])
        end
        # links.push([item["title"],item["link"],"HI"])
        #### break
      end
      @links = randomElements(@links)
      li = []
      for realL in @links
        time = realL[2].to_i
        if (time < @allowedTime)
          @allowedTime -= time
          li.push(realL)
        end
      end
      @links = li
    end

  end
  def randomElements(x)
    y = []
    x = x.shuffle
    for e in x
      if rand(10) > 6
        y.push(e)
      end
    end
    return y
  end
  def randomCombine(x,y)
    z = []
    x = x.shuffle
    y = y.shuffle
    for e in 0..x.length
      if rand(10) > 5
        z.push(x)
      else
        z.push(y)
      end
    end
    return z
  end
end

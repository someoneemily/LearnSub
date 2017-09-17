class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches
  # GET /searches.json
  def index
    # @searches = Search.all

    @time = 10
    if params[:q] and params[:q].length > 0
      # puts params[:q]
      @query = params[:q]
      if params[:time] and params[:time].to_i > 0
        @time = params[:time]
      end
      @shouldshow = true

      @allowedTime = @time.to_i
      puts "TIME " + @time
      query(@query)
    end
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
      @data = `python3 untitled.py --q "#{query}" --duration medium`
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

  # GET /searches/1
  # GET /searches/1.json
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:q, :time)
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

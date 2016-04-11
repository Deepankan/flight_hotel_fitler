class ProductsController < ApplicationController
  #before_action :set_product, only: [:show, :edit, :update, :destroy]
  require 'semantics3'
  require 'json'
require 'rest-client'
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @seatingclass = {'Economy' => 'E','Bussiness Class' => 'B'}
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    #@product = Product.new(product_params)

    # respond_to do |format|
    #   if @product.save
    #     format.html { redirect_to @product, notice: 'Product was successfully created.' }
    #     format.json { render :show, status: :created, location: @product }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @product.errors, status: :unprocessable_entity }
    #   end
    # end
     uploaded_io = params['product'][:file]
    Dir.mkdir(File.join("#{Rails.root}/public", "csv_files"), 0777) unless Dir.exists?("#{Rails.root}/public/csv_files")
    filename = Rails.root.join('public/csv_files',params['product'][:file].original_filename())
    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end
     short_file_name = params['product'][:file].original_filename
    qry =  "load data local infile '#{filename}' into table cities  fields TERMINATED BY ','  ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (city_name,city_id,domestic_flag)  set file_name='#{short_file_name}'"
    upload_file= "COPY cities FROM '#{filename}' DELIMITER ',' CSV"
    ActiveRecord::Base.connection.execute(upload_file)
    redirect_to root_path
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def list_products
  
    sem3 = Semantics3::Products.new(API_KEY,API_SECRET)
    #sem3.products_field( "search", "iphone" )
    sem3.products_field( "search", params["search"] )
    #binding.pry
   # sem3.products_field( "price", "lt", 300)
    productsHash = sem3.get_products()
    @productsHash = productsHash['results'] 
     # binding.pry
  end

  def list_flights
    
    #, :solutions=>20, :refundable=>false
    # {:request=>{:slice=>[{:origin=>"BLR", :destination=>"HYD", :date=>"03/04/2016"}], :passengers=>{:adultCount=>1, :infantInLapCount=>0, :infantInSeatCount=>0, :childCount=>0, :seniorCount=>0}}}

    response ={:request=>{:slice=>[{:origin=> params[:origin], :destination=> params[:destination], :date=> params[:date]}], :passengers=>{:adultCount=>1, :infantInLapCount=>0, :infantInSeatCount=>0, :childCount=>0, :seniorCount=>0}}}
    result = RestClient.post "https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{API_FLIGHT_KEY}",response.to_json,:content_type => :json
    @result = JSON.parse(result)
    
     @list_airport = {}
     @list_city = {}
     @list_aircraft = {}
     @list_carrier = {}
    
     @result['trips']['data']['airport'].each{|h| @list_airport[h['code']] = h['name']}
     @result['trips']['data']['city'].each{|h| @list_city[h['code']] = h['name']}
     @result['trips']['data']['aircraft'].each{|h| @list_aircraft[h['code']] = h['name']}
     @result['trips']['data']['carrier'].each{|h| @list_carrier[h['code']] = h['name']}

  end

  def list_countries
    @location = {}
    @check_in_date = params['check_in_date']
    @check_out_date = params['check_out_date']
      sleep(15.seconds)
    result = RestClient.post "http://api.wego.com/hotels/api/locations/search?key=#{API_HOTEL_KEY}&ts_code=#{API_HOTEL_SECRET}",{:q=> params[:search_country]}.to_json, :content_type => :json
    @result = JSON.parse(result)
    
    @result['locations'].each{|h| @location[h['name']] = h['id']}
  end 
  def get_hotels
    
    #loc = { :location_id => params['selected_country'], :check_in => params['check_in_date'], :check_out => params['check_out_date'],:user_ip=>'direct'}
    #sleep(10.seconds)
    result = RestClient.get "http://api.wego.com/hotels/api/search/new?key=#{API_HOTEL_KEY}&ts_code=#{API_HOTEL_SECRET}&location_id=#{params['selected_country']}&check_in= #{params['check_in_date']}&check_out=#{params['check_out_date']}&user_ip=direct"
    @result = JSON.parse(result)
    sleep(10.seconds)
    list_hotel = RestClient.get "http://api.wego.com/hotels/api/search/#{@result['search_id']}?key=#{API_HOTEL_KEY}&ts_code=#{API_HOTEL_SECRET}"
    
    @list_hotel = JSON.parse(list_hotel)

    @list_district = {}
    @list_hotel['districts'].each {|h| @list_district[h['id'].to_i] = h['name']}
  end  
  def go_search_flights
   params['dep_date']  = params['dep_date'].gsub("-","")
   params['return_date'] =  params['return_date'].gsub("-","") if params['return_date']
   params['children'] = params['children'].present? ? params['children'] : 0
   params['infants'] = params['infants'].present? ? params['infants'] : 0
 
  if params['trip'] == 'one_way'
    result = RestClient.get "http://developer.goibibo.com/api/search/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&format=json&source=#{params['origin']}&destination=#{params['destination']}&dateofdeparture=#{params['dep_date']}&seatingclass=#{params['seatingclass']}&adults=#{params['adults']}&children=#{params['children']}&infants=#{params['infants']}"
  else
    result = RestClient.get "http://developer.goibibo.com/api/search/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&format=json&source=#{params['origin']}&destination=#{params['destination']}&dateofdeparture=#{params['dep_date']}&dateofarrival=#{params['return_date']}&seatingclass=#{params['seatingclass']}&adults=#{params['adults']}&children=#{params['children']}&infants=#{params['infants']}"
  end
  @result = JSON.parse(result)

 
 end 

 def get_min_price_flights
   params['return_date'] = params['return_date'].present? ? params['return_date'] : params['dep_date']
   params['dep_date']  = params['dep_date'].gsub("-","")
   params['return_date'] =  params['return_date'].gsub("-","")   
   result = RestClient.get "http://developer.goibibo.com/api/stats/minfare/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&format=json&vertical=flight&source=#{params['origin']}&destination=#{params['destination']}&mode=all&sdate=#{params['dep_date']}&edate=#{params['return_date']}&seatingclass=#{params['seatingclass']}"
   
   @result = JSON.parse(result)
 end

 def get_list_bus

   params['dep_date']  = params['dep_date'].gsub("-","")
   params['return_date'] =  params['return_date'].gsub("-","") if params['return_date']
   if params['trip_bus'] == 'one_way_bus'
    result = RestClient.get "http://developer.goibibo.com/api/bus/search/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&format=json&source=#{params['origin']}&destination=#{params['destination']}&dateofdeparture=#{params['dep_date']}"
   else
    result = RestClient.get "http://developer.goibibo.com/api/bus/search/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&format=json&source=#{params['origin']}&destination=#{params['destination']}&dateofdeparture=#{params['dep_date']}&dateofarrival=#{params['return_date']}"
   end
   @result = JSON.parse(result)  

 end  
  def get_hotel_list
   params['dep_date']  = params['dep_date'].gsub("-","")
   params['return_date'] =  params['return_date'].gsub("-","")   
   city_id = City.find_by_city_name(params[:city]).city_id
  get_name_result = RestClient.get "http://developer.goibibo.com/api/voyager/get_hotels_by_cityid/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&city_id=#{city_id}"
  @hotel_name = JSON.parse(get_name_result)   
  
  result = RestClient.get "http://developer.goibibo.com/api/cyclone/?app_id=#{API_APP_ID_GOIBIBO}&app_key=#{API_APP_KEY_GOIBIBO}&city_id=#{city_id}&check_in=#{params['dep_date']}&check_out=#{params['return_date']}"
  @result = JSON.parse(result)   

  end 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.fetch(:product, {})
    end
end

class ProductsController < ApplicationController
  #before_action :set_product, only: [:show, :edit, :update, :destroy]
  require 'semantics3'
  require 'json'
require 'rest-client'
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
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
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
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
    #sleep(15.seconds)
    result = RestClient.get "http://api.wego.com/hotels/api/search/new?key=#{API_HOTEL_KEY}&ts_code=#{API_HOTEL_SECRET}&location_id=#{params['selected_country']}&check_in= #{params['check_in_date']}&check_out=#{params['check_out_date']}&user_ip=direct"
    @result = JSON.parse(result)
    #sleep(15.seconds)
    list_hotel = RestClient.get "http://api.wego.com/hotels/api/search/#{@result['search_id']}?key=#{API_HOTEL_KEY}&ts_code=#{API_HOTEL_SECRET}"
    
    @list_hotel = JSON.parse(list_hotel)

    @list_district = {}
    @list_hotel['districts'].each {|h| @list_district[h['id'].to_i] = h['name']}
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

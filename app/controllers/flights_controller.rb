class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :edit, :update, :destroy]

  def list        

    sql_str = ""

    if params[:price] != ""      
      sql_str += " AND CAST(flights.price AS Integer) <= #{params[:price]}"
    end 
    
    if params[:airline] != ""
      sql_str += " AND flights.airline = '#{params[:airline]}'"
    end

    @flights = Flight.find_by_sql("
      Select * FROM flights 
      inner join airlines 
      on flights.airline = airlines.airline       
      where flights.departure_airport = '#{params[:departure_airport]}'
      and flights.arrival_airport = '#{params[:arrival_airport]}'
      and DATE(flights.departure_time) = '#{params[:departure_time]}' " + sql_str + " 
      order by departure_time, price")
  end  

  # GET /flights
  # GET /flights.json
  def index
    @flights = Flight.all
  end

  # GET /flights/1
  # GET /flights/1.json
  def show
  end

  # GET /flights/new
  def new
    @flight = Flight.new
  end

  # GET /flights/1/edit
  def edit
  end

  # POST /flights
  # POST /flights.json
  def create
    @flight = Flight.new(flight_params)

    respond_to do |format|
      if @flight.save
        format.html { redirect_to @flight, notice: 'Flight was successfully created.' }
        format.json { render :show, status: :created, location: @flight }
      else
        format.html { render :new }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flights/1
  # PATCH/PUT /flights/1.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to @flight, notice: 'Flight was successfully updated.' }
        format.json { render :show, status: :ok, location: @flight }
      else
        format.html { render :edit }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    @flight.destroy
    respond_to do |format|
      format.html { redirect_to flights_url, notice: 'Flight was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flight
      @flight = Flight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flight_params
      params.require(:flight).permit(:airline, :departure_airport, :arrival_airport, :departure_time, :arrival_time, :flight_status, :rev_departure_time, :rev_arrival_time, :is_delete, :created_at, :price)
    end
end

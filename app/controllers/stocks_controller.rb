class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  before_action :check_admin
  before_action :set_exchange, only: %i[new next create edit update]
  before_action :check_active

  # GET /stocks or /stocks.json
  def index
    @stocks = current_user.stocks
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  def next
    split_str = params[:symbol].split('+')
    @symbol = split_str[0]
    @name = split_str[1] 
    @qoute = @client.quote(@symbol)
    @stock = Stock.new
  end

  # GET /stocks/new
  def new
    @symbols = @client.ref_data_symbols
  end

  # GET /stocks/1/edit
  def edit
    @qoute = @client.quote(@stock[:symbol])
  end

  # POST /stocks or /stocks.json
  def create
    @stock = current_user.stocks.new(stock_params)
    current_user.balance -= (@stock.count * @stock.value)

    if current_user.balance < 0
      flash.now[:alert] = "Insufficient Balance"
      redirect_to :back
      return
    else
      current_user.save
    end
    

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    stock = current_user.stocks.find(params[:id])
    qoute = @client.quote(stock[:symbol])
    stock.value = qoute.latest_price
    stock.count = params[:commit] == "Buy" ? stock.count + params[:change][:count_delta].to_i : stock.count - params[:change][:count_delta].to_i

    current_user.balance = params[:commit] == "Buy" ? current_user.balance.to_i - (params[:change][:count_delta].to_i * qoute.latest_price).to_i : current_user.balance.to_i + (params[:change][:count_delta].to_i * qoute.latest_price).to_i

    if stock.count < 0
      flash.now[:alert] = "Insufficient Inventory"
      return
    end
    if params[:commit] == "Buy" && current_user.balance < 0
      flash.now[:alert] = "Insufficient Balance"
      return
    else
      current_user.save
    end


    respond_to do |format|
      if stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def check_active
      if (!current_user.is_active)
        redirect_to "/inactive-account"
      end
    end

    def check_admin
      if (current_user.admin)
        redirect_to "/admin"
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:stock_name, :symbol, :desc, :value, :count)
    end


    def set_exchange
      @client = IEX::Api::Client.new ({
        publishable_token: ENV['PUBLISHABLE_TOKEN'],
        secret_token: ENV['SECRET_TOKEN'],
        endpoint: 'https://cloud.iexapis.com/v1'
      }
      )
    end
end

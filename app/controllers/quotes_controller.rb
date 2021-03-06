class QuotesController < ApplicationController
  before_action :authenticate_user! #, except: [:new]

    def index
      @quotes = Quote.all
      render 'index'
    end

    def new
      @quote = Quote.new
    end

    def create
    #the first line below simply returns the URL parameters as a basic text hash
    @quote = Quote.new(quote_params)
    puts "The params are #{quote_params}."

    if @quote.save
      respond_to do |format|
        puts "The slug URL is #{@quote.slug}"
        UserMailer.welcome_email(@quote).deliver_now
        format.html { redirect_to(@quote, notice: 'A new estimate was successfully created.')}
        format.json { render json: @quote, status: created, location: @quote }
      # render 'show'
      #redirect_to @quote
      end
    else
      render 'new'
      #send email to admin saying an invalid email signup was attempted(?)
    end
end

def edit
  @quote = Quote.find_by_slug(params[:id])
end

def update
  @quote = Quote.find_by_slug(params[:id])
  if @quote.update(quote_params)
    redirect_to @quote
  else
    render 'edit'
  end
end

def show
  @quote = Quote.find_by_slug(params[:id])
end

def save_quote
end


def destroy
  @quote = Quote.find_by_slug(params[:id])
  @quote.destroy
  redirect_to quotes_path
end

def custom_404
  render '404'
end

def thank_you
  render 'thank_you'
end

private
  # Anytime new fields are added to the model, they must be included here in order to be passed through the URL as params
  def quote_params
    # params.permit(:quote, :first_name, :last_name, :email, :neighborhood, :bedrooms, :bathrooms, :condition, :current_rent, :file)

    params.require(:quote).permit(:first_name, :last_name, :email, :neighborhood, :bedrooms, :bathrooms, :condition, :current_rent)


  end

end

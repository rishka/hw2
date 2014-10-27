class MoviesController < ApplicationController
  helper_method :sorted_col, :check_ratings
  def initialize
    @all_ratings = Movie.all_ratings
    super
  end
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil or (params[:field_name == nil] and session[:field_name] != nil)
      if params[:field_name] == nil
        if session[:field_name] == nil
          params[:field_name] = session[:field_name]
        end
      end
      if session[:ratings] == nil
        params[:ratings] = Hash.new
        @all_ratings.each {|rating| params[:ratings][rating] = 1}
        session[:ratings] = params[:ratings]
      else
        params[:ratings] = session[:ratings]
      end
      redirect_to movies_path(params)
    end
    session[:ratings] = params[:ratings]
    session[:field_name] = params[:field_name]
    @movies = Movie.order((sorted_col).to_s + " asc")
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  def sorted_col
    Movie.column_names.include?(params[:field_name]) ? params[:field_name] : :id
  end

  def check_ratings(rating)
    params[:ratings][rating]
  end
end

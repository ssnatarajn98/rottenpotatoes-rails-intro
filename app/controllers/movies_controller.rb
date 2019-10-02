class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] 
    @movie = Movie.find(id) 
    
  end

  def index
    @movies = Movie.all
    @ar = Movie.get_rating_options

    if params[:ratings]
      @ratings = params[:ratings].keys
      session[:filtered_rating] = @ratings
    elsif session[:filtered_rating]
      q = Hash.new
      session[:filtered_rating].each do |r|
        q['ratings['+ r + ']'] = 1
      end
      session[:filtered_rating] = nil
      q['sort'] = params[:sort] if params[:sort]
      flash.keep
      redirect_to movies_path(q)
    else
      @ratings = @ar
    end

    @movies.where!(rating: @ratings)
    case params[:sort]
    when 'title'
      @movies.order!('title asc')
      @title_class = "hilite"
    when 'release_date'
      @movies.order!('release_date asc')
      @release_date_class = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

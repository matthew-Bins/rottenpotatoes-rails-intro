class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.getratings
    redirect = false
    
    #check for ratings session
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @selected_ratings = session[:ratings]
    elsif session[:ratings]
      redirect = true
    else
      #no rating restrictions
      @selected_ratings = Hash.new
      @all_ratings.each do |x| @selected_ratings[x] = 1 end
    end
    
    #check for sort session
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      redirect = true
    end
    
    @sort = session[:sort]
    
    #redirect if need to
    if redirect
      flash.keep
      redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort]) and return
    end
    
    #do action
    if params[:ratings] and params[:sort]
      @movies = Movie.where(:rating => @selected_ratings.keys).order(params[:sort])
    elsif params[:sort]
      @movies = Movie.order(params[:sort])
      
    elsif params[:ratings]
      @selected_ratings = session[:ratings]
      @movies = Movie.where(:rating => @selected_ratings.keys)
    else
      @movies = Movie.all
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

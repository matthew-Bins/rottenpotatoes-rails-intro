class Movie < ActiveRecord::Base
    #belongs_to :rating
    
    def self.getratings
       movie_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
       movie_ratings
    end
end

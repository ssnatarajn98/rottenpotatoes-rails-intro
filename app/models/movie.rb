class Movie < ActiveRecord::Base
    def self.get_rating_options
        pluck('DISTINCT rating').sort!
      end
end

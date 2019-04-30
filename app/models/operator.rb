class Operator < ActiveRecord::Base
    
    # short module to generate a secret token used for minimal authentication
    # for api requests. not quite suitable for production
    module RandomToken
        def self.random(len=32, character_set = ["A".."Z", "a".."z", "0".."9"])
            chars = character_set.map{|x| x.is_a?(Range) ? x.to_a : x }.flatten
            Array.new(len){ chars.sample }.join
        end
    end
    
    devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
    
    has_many :machines, dependent: :destroy
    before_create :generate_secret_token
    
    private
    
    # method for generating secret token. ensures uniqueness of each token
    def generate_secret_token
        token = RandomToken.random(15)
        
        until !Operator.exists?(secret_token: token)
          generate_access_token
        end
        
        self.secret_token = token
    end
end
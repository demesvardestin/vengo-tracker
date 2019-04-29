class Operator < ActiveRecord::Base
    
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
    
    validates_presence_of :name
    
    private
    
    def generate_secret_token
        token = RandomToken.random(15)
        
        until !Operator.exists?(secret_token: token)
          generate_access_token
        end
        
        self.secret_token = token
    end
end
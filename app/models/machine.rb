class Machine < ActiveRecord::Base
    belongs_to :operator
    has_many :products, dependent: :destroy
    has_many :trackers, through: :products
    
    before_create :randomize_location
    
    validates_presence_of :latitude unless :not_auto_generated
    validates_presence_of :longitude unless :not_auto_generated
    
    # machine location by latitude and longitude, for simplicity's sake.
    # future implementations could include full address
    def full_location
        Geocoder.search("#{latitude}, #{longitude}").first.display_name
    end
    
    # machine's current total inventory count from all products
    def total_inventory_count
        products.map(&:current_inventory_count).sum
    end
    
    # all time total items sold
    def total_items_sold
        trackers.map(&:current_value).sum
    end
    
    # this method creates a random number of products ranging from 1 to 6,
    # to fill the machine's slots
    def fill_product_slots(id)
        rand(1..6).times.each do |t|
            Product.create(machine_id: id, threshold: 0, auto_generated: true)
        end
    end
    
    # simple function for randomly generating (installing) an arbitrary number
    # of machines
    def self.generate_random(count, operator)
        machines = []
        count.times.each do |t|
            machines << Machine.create(operator_id: operator.id, auto_generated: true)
        end
        
        machines.each { |m| m.fill_product_slots(m.id) }
    end
    
    # checks if more product slots can be added
    def has_slots_available
        (6 - products.count) > 0
    end
    
    protected
    
    # this method randomizes machine location. latitude and longitude bounds
    # are chosen in order to restrict machine location to NYS area
    def randomize_location
        if self.auto_generated
            self.latitude = rand(40.60000..40.88600)
            self.longitude = rand(-74.08089..-72.21063)
        end
    end
    
    def not_auto_generated
        !self.auto_generated
    end
end
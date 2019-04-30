require 'sendgrid-ruby'

class Product < ActiveRecord::Base
    include SendGrid
    belongs_to :machine
    has_one :tracker, dependent: :destroy
    
    before_create :randomize_category # randomize product name and max inventory count
    after_create :create_sales_tracker # create a sales tracker
    after_update :send_email if Rails.env.production? # only send email if in production
    
    validates_presence_of :current_inventory_count, :max_inventory_count,
        :threshold, :name unless :not_auto_generated
    
    # total items sold
    def total_sold
        tracker.current_value
    end
    
    # inventory status
    def status
        if current_inventory_count == 0
            "Out of Stock"
        elsif current_inventory_count <= threshold
            "Low"
        else
            "Stocked"
        end
    end
    
    # checks if inventory is running low for specific product
    def running_low
        status == "Low" || status == "Out of Stock"
    end
    
    # checks if inventory is out of stock for specific product
    def out_of_stock
        status == "Out of Stock"
    end
    
    # update product tracker to reflect sales made
    def update_tracker(old=nil, new=nil)
        if old && new
            tracker.update(current_value: tracker.current_value + (old - new))
            return
        end
        
        current_tracker_value = tracker.current_value
        tracker.update(current_value: current_tracker_value + 1)
    end
    
    protected
    
    def self.possible_products
        # array of random product names and maximum inventory counts
        [
            {"name": "Electronics", "max_count": 10},
            {"name": "Personal Care", "max_count": 6},
            {"name": "Utilities", "max_count": 8},
            {"name": "Snacks", "max_count": 4},
            {"name": "Drinks", "max_count": 7},
            {"name": "Medications", "max_count": 9},
        ]
    end
    
    def randomize_category(machine=nil)
        # if product creation is not random, stop running function
        if !self.auto_generated
            return
        end
        
        # in case machine argument is nil, find machine by machine_id
        machine = machine || Machine.find(self.machine_id)
        # map current product names in array
        machine_products_names = machine.products.map(&:name)
        # get random category
        selected_category = Product.possible_products[rand(0..5)]
        
        # recursively check if the selected category is already in the machine's
        # current products. if it's not, continue to end of function
        until !machine_products_names.include?(selected_category[:name])
            randomize_category(machine)
            return
        end
        
        # finally, set product details
        self.name = selected_category[:name]
        self.current_inventory_count = selected_category[:max_count]
        self.max_inventory_count = selected_category[:max_count]
        self.threshold = selected_category[:max_count]/2
    end
    
    def create_sales_tracker
        # this object tracks the product's sales
        Tracker.create(product_id: self.id, current_value: 0)
    end
    
    def not_auto_generated
        !self.auto_generated
    end
    
    def send_email
        # only send email once, when product inventory has just dipped below
        # the threshold level
        if self.current_inventory_count == (threshold - 1)
            from = SendGrid::Email.new(email: 'alert@vengotracker.com')
            to = SendGrid::Email.new(email: self.machine.operator.email)
            subject = "Some inventory products in Machine #{self.machine.id} are running low"
            content_value = """
                            Machine ID: #{self.machine.id}
                            Product ID: #{self.id}
                            Product Name: #{self.name}
                            Product Current Inventory Count: #{self.current_inventory_count}
                            Product Max Inventory Count: #{self.max_inventory_count}
                            Product Threshold: #{self.threshold}
                            """
            content = SendGrid::Content.new(type: 'text/plain', value: content_value)
            mail = SendGrid::Mail.new(from, subject, to, content)
            
            sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
            response = sg.client.mail._('send').post(request_body: mail.to_json)
            puts response.status_code
            puts response.body
        end
    end
end

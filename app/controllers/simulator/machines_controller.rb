class Simulator::MachinesController < ActionController::Base
    layout "simulator/layouts/application"
    before_action :authenticate_operator!
    before_action :set_machine, except: :index
    
    # simulator index page
    def index
        @machines = current_operator.machines
    end
    
    # buy simulator. reduce current inventory count by 1
    def buy
        @product = @machine.products.find(params[:product_id])
        # get old inventory count and new inventory count
        old, new = @product.current_inventory_count, (@product.current_inventory_count - 1)
        # update product
        @product.update(current_inventory_count: new)
        # update tracker
        @product.update_tracker
        
        render :layout => false
    end
    
    # refill simulator. update product inventory count to max capacity
    def refill
        @product = @machine.products.find(params[:product_id])
        max_inventory_count = @product.max_inventory_count
        @product.update(current_inventory_count: max_inventory_count)
        
        render :layout => false
    end
    
    private
    
    def set_machine
        @machine = Machine.find(params[:id])
    end
end
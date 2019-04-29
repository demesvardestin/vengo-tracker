# PRODUCT API ENDPOINTS

require_relative 'api_controller.rb'

class Api::ProductsController < ApiController
    before_action :set_product, except: [:index, :create]
    before_action :set_machine, only: :create
    
    # GET products
    def index
        @machine = Machine.find(params[:machine_id])
        @products = @machine.products
        
        render json: @products
    end
    
    # GET product
    def show
        render json: @product
    end
    
    # POST products
    def create
        @product = Product.new(product_params)
        @product.machine = @machine
        
        # prevents adding more than 6 products to a machine
        if @machine.products.size >= 6 && !params.empty?
            render json: { :message => "Reached maximum slots for this machine" }, status: 201
            return
        end
        
        # rescues against validation error
        begin
            @product.save!
            render json: @product, status: 201
            return
        rescue
            render json: { :message => "Validation failed" }, status: 422
            return
        end
    end
    
    # PUT product
    def update
        old, new = @product.current_inventory_count, params[:current_inventory_count]
        @product.update(product_params)
        @product.update_tracker old.to_i, new.to_i
        
        head :no_content
    end
    
    # DELETE product
    def destroy
        @product.destroy
        head :no_content
    end
    
    private
    
    def product_params
        params.permit(:current_inventory_count, :max_inventory_count, :threshold, :name)
    end
    
    def set_product
        @product = Product.find(params[:id])
    end
    
    def set_machine
        @machine = Machine.find(params[:machine_id])
    end
end
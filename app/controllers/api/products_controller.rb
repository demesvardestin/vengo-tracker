# PRODUCT API ENDPOINTS

require_relative 'api_controller.rb'

class Api::ProductsController < ApiController
    before_action :set_product, except: [:index, :create]
    before_action :set_machine, :check_products_count, only: :create
    before_action :find_operator
    
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
    
    # prevents adding more than 6 products to a machine
    def check_products_count
        set_machine
        if @machine.products.size >= 6 && !params[:name].nil?
            render json: { :message => "Reached maximum slots for this machine" }, status: 201
            return
        end
    end
    
    def find_operator
        @operator = current_operator || Operator.find_by(secret_token: params[:secret_token])
        
        if @operator.nil?
            render json: { :message => "We were unable to authenticate you" }, :status => 401
        end
    end
end
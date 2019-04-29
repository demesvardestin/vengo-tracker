class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show]
  
  # product form page
  def new
    @machine = Machine.find(params[:machine_id])
    @product = Product.new
  end
  
  # CREATE product
  def create
    @product = Product.new(product_params)
    @product.machine_id = params[:machine_id]
    @product.name = @product.name.capitalize
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product.machine, notice: "#{@product.name} added with #{@product.current_inventory_count} items!" }
      end
    end
  end
  
  # UPDATE product
  def update
    old, new = @product.current_inventory_count, params[:product][:current_inventory_count]
    @product.update(product_params)
    @product.update_tracker old.to_i, new.to_i
    
    respond_to do |format|
      format.html { redirect_to edit_machine_path(@product.machine), notice: "#{@product.name} details updated!" }
    end
  end
  
  private
  
  def product_params
    params.require(:product).permit(:max_inventory_count, :current_inventory_count, :name, :threshold)
  end
  
  def set_product
    @product = Product.find(params[:id])
  end
end

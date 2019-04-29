class MachinesController < ApplicationController
  before_action :authenticate_operator!
  before_action :set_machine, only: [:show, :edit, :update]
  
  # GET machine list
  def index
    @machines = current_operator.machines
    @machine = Machine.new
  end
  
  # UPDATE machine
  def update
    @machine.update(machine_params)
    respond_to do |format|
      format.html { redirect_to @machine, notice: "Vengo Machine Updated!" }
    end
  end
  
  # CREATE machine
  def create
    @machine = Machine.new(machine_params)
    @machine.operator = current_operator
    
    respond_to do |format|
      if @machine.save
        format.html { redirect_to "/", notice: "New Vengo machine added. ID: #{@machine.id}" }
      else
        format.html { redirect_to "/", notice: "Vengo Machine couldn't be added. Please try again!" }
      end
    end
  end
  
  # generate (install) random number of machines
  def generate_random
    Machine.generate_random params[:count].to_i, current_operator
    redirect_to "/", notice: "#{params[:count].to_i} Vengo Machines have been installed!"
  end
  
  private
  
  def set_machine
    @machine = Machine.find(params[:id])
  end
  
  def machine_params
    params.require(:machine).permit(:latitude, :longitude, :operator)
  end
end

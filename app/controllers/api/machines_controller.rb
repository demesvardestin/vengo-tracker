# MACHINE API ENDPOINTS

require_relative 'api_controller.rb'

class Api::MachinesController < ApiController
    before_action :set_machine, except: [:index, :create]
    before_action :find_operator
    
    # GET /api/machines
    def index
        @machines = begin
            find_operator.machines
        rescue
            Machine.where(operator_id: params[:operator_id])
        end
        
        render json: @machines
    end
    
    # GET /api/machines/:id
    def show
        render json: @machine
    end
    
    # POST /api/machines
    def create
        @machine = Machine.new(machine_params)
        @machine.operator = find_operator
        @machine.save!
        
        render json: @machine, status: 201
    end
    
    # PUT /api/machines/:id
    def update
        @machine.update(machine_params)
        
        head :no_content
    end
    
    # DELETE /api/machines/:id
    def destroy
        @machine.destroy
        
        head :no_content
    end
    
    private
    
    def machine_params
        params.permit(:longitude, :latitude)
    end
    
    def set_machine
        @machine = Machine.find(params[:id])
    end
    
    # authentication check: devise user (web) and jwt user (api)
    def find_operator
        @operator = current_operator
    end
end
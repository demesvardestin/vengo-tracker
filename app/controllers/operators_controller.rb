class OperatorsController < ApplicationController
    before_action :authenticate_operator!
    before_action :set_operator, only: [:account, :update, :analytics]
    
    def update
        @operator.update(operator_params)
        respond_to do |format|
            format.html { redirect_to "/account", notice: "Your account has been updated!" }
        end
    end
    
    private
    
    def operator_params
        params.require(:operator).permit(:name)
    end
    
    def set_operator
        @operator = current_operator
    end
end

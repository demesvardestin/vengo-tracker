class OperatorsController < ApplicationController
    before_action :authenticate_operator!
    before_action :set_operator, only: [:account, :update, :generate_secret_token]
    
    def update
        @operator.update(operator_params)
        respond_to do |format|
            format.html { redirect_to operator_account_path(@operator), notice: "Your account has been updated!" }
        end
    end
    
    def generate_secret_token
        @operator.update(secret_token: Operator::RandomToken.random(15))
        respond_to do |format|
            format.html { redirect_to operator_account_path(@operator), notice: "New Secret Token Generated!" }
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

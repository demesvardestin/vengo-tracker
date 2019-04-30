class MachineNotification < ApplicationMailer
    
    def send_low_inventory_alert_to(operator, product)
        @operator = operator
        @product = product
        @machine = @product.machine
        @url = "https://vengo-tracker.herokuapp.com/simulator/machines/#{@machine.id}"
        subject = "Machine #{@machine.id}'s' inventory is running low!"
        
        mail(to: @operator.email, subject: subject)
    end
end

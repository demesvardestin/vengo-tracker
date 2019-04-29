module ApplicationHelper
    def navbar
        if current_operator
            "layouts/operator_navbar"
        else
            "layouts/base_navbar"
        end
    end
    
    def footer
        if !current_operator
            "layouts/footer"
        else
            "layouts/no_footer"
        end
    end
    
    def some_need_refill(machine)
        machine.products.any? { |prod| prod.status == "Low" } ? "show" : "hide"
    end
    
    def some_need_restock(machine)
        machine.products.any? { |prod| prod.status == "Out of Stock" } ? "show" : "hide"
    end
end

module VendingMachine
  class ChangeDispenser
    def dispense_balance(change_due)
      dispense_coins(change_due.in_coins)
      dispense_bills(change_due.in_bills)
    end

    def dispense_coins(amount)
      # use the appropriate low-level electronics API here
    end

    def dispense_bills(amount)
      # use the appropriate low-level electronics API here
    end
  end
end
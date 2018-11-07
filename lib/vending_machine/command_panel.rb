require "vending_machine/change_dispenser"

module VendingMachine
  class CommandPanel
    attr_reader :account, :change_dispenser

    def initialize(
      account:,
      change_dispenser: ChangeDispenser.new
    )
      @account = account
      @change_dispenser = change_dispenser
    end

    def push_button(name)
      change_dispenser.dispense_balance(account)
    end
  end
end
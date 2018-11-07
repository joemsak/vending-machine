require "vending_machine/account"
require "vending_machine/change_dispenser"

module VendingMachine
  class CommandPanel
    attr_reader :account, :change_dispenser

    def initialize(account: nil, change_dispenser: nil)
      @account = account || Account.new
      @change_dispenser = change_dispenser || ChangeDispenser.new
    end

    def push_button(name)
      case name
      when :cancel
        change_dispenser.dispense_balance(account)
      end
    end
  end
end
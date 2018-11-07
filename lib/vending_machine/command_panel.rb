module VendingMachine
  class CommandPanel
    attr_reader :account, :change_dispenser

    def initialize(account:, change_dispenser:)
      @account = account
      @change_dispenser = change_dispenser
    end

    def push_button(name)
      change_dispenser.dispense(account.balance)
    end
  end
end
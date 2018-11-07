require 'vending_machine/money'

module VendingMachine
  class Account
    attr_reader :balance

    private
    attr_writer :balance

    public
    def initialize
      @balance = 0
    end

    def add_funds(amount)
      money = Money.new(amount)

      if money.acceptable?
        self.balance += money.amount
      end
    end
  end
end
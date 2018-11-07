require 'vending_machine/money'

module VendingMachine
  class Account
    attr_reader :balance, :change_due

    private
    attr_writer :balance, :change_due

    public
    def initialize
      @balance = 0
      @change_due = 0
    end

    def add_funds(amount)
      money = Money.new(amount)

      if money.acceptable?
        self.balance += money.amount
      end

      self.change_due += money.amount
    end
  end
end
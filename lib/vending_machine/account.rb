require 'vending_machine/money'

module VendingMachine
  class Account
    private
    attr_writer :balance

    public
    def initialize
      @balance = 0
    end

    def balance
      @balance.round(2)
    end

    def add_funds(amount)
      money = Money.new(amount)

      if money.acceptable?
        self.balance += money.amount
      end
    end

    def subtract_funds(amount)
      self.balance -= amount
    end

    def reset_balance
      change_due = ChangeDue.new(balance)
      self.balance = 0
      change_due
    end

    class ChangeDue
      attr_reader :in_bills, :in_coins

      def initialize(amount)
        split = String(amount).split(".")

        @in_bills = split.first.to_i

        if split.size == 2
          @in_coins = split.last.to_i / 100.0
        else
          @in_coins = 0
        end
      end
    end
  end
end
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
      else
        self.change_due += money.amount
      end
    end

    class Money
      attr_reader :amount

      def initialize(amount)
        @amount = amount
      end

      def acceptable?
        [0.05, 0.1].include?(amount)
     end
    end
  end
end
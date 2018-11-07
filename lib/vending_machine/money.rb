module VendingMachine
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
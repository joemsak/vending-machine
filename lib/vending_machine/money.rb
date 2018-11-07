module VendingMachine
  class Money
    attr_reader :amount

    ACCEPTED_DENOMINATIONS = [
      0.05,
      0.10,
      0.25,
      1,
      5,
      10,
    ]

    def initialize(amount)
      @amount = amount
    end

    def acceptable?
      ACCEPTED_DENOMINATIONS.include?(amount)
    end
  end
end
require "spec_helper"
require "vending_machine/balance_handler"

RSpec.describe VendingMachine::BalanceHandler do
  describe "#current_balance" do
    it "starts at 0" do
      balance_handler = VendingMachine::BalanceHandler.new
      expect(balance_handler.current_balance).to eq(0)
    end

    it "rejects pennies"
    it "rejects bills greater than $10"
    it "accepts nickels"
    it "accepts dimes"
    it "accepts quarters"
    it "accepts $1 bills"
    it "accepts $5 bills"
    it "accepts $10 bills"
    it "accepts a mix of valid coins & bills"
  end
end
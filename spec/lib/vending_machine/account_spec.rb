require "spec_helper"
require "vending_machine/account"

RSpec.describe VendingMachine::Account do
  describe "#balance" do
    it "starts at 0" do
      account = VendingMachine::Account.new
      expect(account.balance).to eq(0)
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
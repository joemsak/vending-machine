require "spec_helper"
require "vending_machine/account"

RSpec.describe VendingMachine::Account do
  describe "#balance" do
    it "starts at 0" do
      account = VendingMachine::Account.new
      expect(account.balance).to eq(0)
    end
  end

  describe "#change_due" do
    it "starts at 0" do
      account = VendingMachine::Account.new
      expect(account.change_due).to eq(0)
    end
  end

  describe "#add_funds" do
    it "rejects pennies" do
      account = VendingMachine::Account.new

      account.add_funds(0.01)

      expect(account.balance).to eq(0)
      expect(account.change_due).to eq(0.01)
    end

    it "rejects bills greater than $10" do
      account = VendingMachine::Account.new

      amount = [20, 50, 100].sample
      account.add_funds(amount)

      expect(account.balance).to eq(0)
      expect(account.change_due).to eq(amount)
    end

    it "accepts nickels"
    it "accepts dimes"
    it "accepts quarters"
    it "accepts $1 bills"
    it "accepts $5 bills"
    it "accepts $10 bills"
    it "accepts a mix of valid coins & bills"
  end
end
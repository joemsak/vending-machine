require "spec_helper"
require "vending_machine/account"

RSpec.describe VendingMachine::Account do
  describe "#balance" do
    it "starts at 0" do
      account = VendingMachine::Account.new
      expect(account.balance).to eq(0)
    end
  end

  describe "#reset_balance" do
    it "resets the balance to 0" do
      account = VendingMachine::Account.new
      account.add_funds(1)
      account.reset_balance
      expect(account.balance).to eq(0)
    end

    it "returns an Account::ChangeDue object" do
      account = VendingMachine::Account.new

      account.add_funds(1)
      account.add_funds(0.05)

      change_due = account.reset_balance

      expect(change_due.in_bills).to eq(1)
      expect(change_due.in_coins).to eq(0.05)
    end
  end

  describe "#subtract_funds" do
    it "decreases the balance by the amount given" do
      account = VendingMachine::Account.new
      account.add_funds(5)
      account.subtract_funds(2.50)
      expect(account.balance).to eq(2.50)
    end
  end

  describe "#add_funds" do
    it "rejects pennies" do
      account = VendingMachine::Account.new

      account.add_funds(0.01)

      expect(account.balance).to eq(0)
    end

    it "rejects bills greater than $10" do
      account = VendingMachine::Account.new

      amount = [20, 50, 100].sample
      account.add_funds(amount)

      expect(account.balance).to eq(0)
    end

    it "accepts nickels" do
      account = VendingMachine::Account.new
      account.add_funds(0.05)
      expect(account.balance).to eq(0.05)
    end

    it "accepts dimes" do
      account = VendingMachine::Account.new
      account.add_funds(0.10)
      expect(account.balance).to eq(0.10)
    end

    it "accepts quarters" do
      account = VendingMachine::Account.new
      account.add_funds(0.25)
      expect(account.balance).to eq(0.25)
    end

    it "accepts $1 bills" do
      account = VendingMachine::Account.new
      account.add_funds(1.00)
      expect(account.balance).to eq(1.00)
    end

    it "accepts $5 bills" do
      account = VendingMachine::Account.new
      account.add_funds(5.00)
      expect(account.balance).to eq(5.00)
    end

    it "accepts $10 bills" do
      account = VendingMachine::Account.new
      account.add_funds(10.00)
      expect(account.balance).to eq(10.00)
    end

    it "accepts a mix of valid coins & bills" do
      account = VendingMachine::Account.new

      account.add_funds(0.05)
      account.add_funds(0.10)
      account.add_funds(0.10)
      account.add_funds(0.05)
      account.add_funds(0.25)
      account.add_funds(1)
      account.add_funds(10)
      account.add_funds(5)
      account.add_funds(5)
      account.add_funds(0.25)
      account.add_funds(0.25)

      expect(account.balance).to eq(22.05)
    end
  end
end
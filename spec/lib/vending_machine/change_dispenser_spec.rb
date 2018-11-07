require "spec_helper"
require "vending_machine/change_dispenser"

RSpec.describe VendingMachine::ChangeDispenser do
  describe "#dispense_balance" do
    it "resets the account balance, sending coins to the coin bin" do
      change_due = double(:change_due, in_bills: 12, in_coins: 0.35)
      account = double(:account, reset_balance: change_due)

      dispenser = VendingMachine::ChangeDispenser.new

      # low-level machine docs claim
      # that it will efficiently choose
      # the right coins
      expect(dispenser).to receive(:dispense_coins).with(0.35)
      dispenser.dispense_balance(account)
    end

    it "resets the account balance, sending bills out the bill collector" do
      change_due = double(:change_due, in_bills: 12, in_coins: 0.35)
      account = double(:account, reset_balance: change_due)

      dispenser = VendingMachine::ChangeDispenser.new

      # low-level machine docs claim
      # that it will efficiently choose
      # the right bills
      expect(dispenser).to receive(:dispense_bills).with(12)
      dispenser.dispense_balance(account)
    end
  end
end
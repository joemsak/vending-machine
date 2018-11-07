require "spec_helper"
require "vending_machine/change_dispenser"

RSpec.describe VendingMachine::ChangeDispenser do
  describe "#dispense_balance" do
    it "sends coins to the coin bin" do
      change_due = double(:change_due, in_bills: 12, in_coins: 0.35)

      dispenser = VendingMachine::ChangeDispenser.new

      expect(dispenser).to receive(:dispense_coins).with(0.35)
      dispenser.dispense_balance(change_due)
    end

    it "sends bills out the bill collector" do
      change_due = double(:change_due, in_bills: 12, in_coins: 0.35)

      dispenser = VendingMachine::ChangeDispenser.new

      expect(dispenser).to receive(:dispense_bills).with(12)
      dispenser.dispense_balance(change_due)
    end
  end
end
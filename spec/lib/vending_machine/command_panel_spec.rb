require "spec_helper"
require "vending_machine/command_panel"

RSpec.describe VendingMachine::CommandPanel do
  describe "#push_button" do
    context ":cancel" do
      it "tells the change dispenser to dispense the account balance" do
        account = double(:account)
        change_dispenser = double(:change_dispenser)

        command_panel = VendingMachine::CommandPanel.new(
          account: account,
          change_dispenser: change_dispenser,
        )

        expect(change_dispenser).to receive(:dispense_balance).with(account)

        command_panel.push_button(:cancel)
      end
    end
  end
end
require "spec_helper"
require "vending_machine/command_panel"

RSpec.describe VendingMachine::CommandPanel do
  describe "#push_button" do
    context ":a, :b, :c, :d, :e, :f, and :g" do
      it "stores the row name as such" do
        command_panel = VendingMachine::CommandPanel.new

        row_name = %i{a b c d e f g}.sample
        command_panel.push_button(row_name)

        expect(command_panel.selected_row).to eq(row_name)
      end
    end

    context "0 through 9" do
      it "does nothing without a selected row" do
        command_panel = VendingMachine::CommandPanel.new

        column_num = Array(0..9).sample

        command_panel.push_button(column_num)
        expect(command_panel.selected_column).to be_nil
      end

      it "sets the selected column" do
        command_panel = VendingMachine::CommandPanel.new

        column_num = Array(0..9).sample

        command_panel.push_button(:d)
        command_panel.push_button(column_num)
        expect(command_panel.selected_column).to eq(column_num)
      end
    end

    context ":cancel" do
      it "gets the change due from resetting the account balance" do
        account = double(:account, reset_balance: double.as_null_object)

        command_panel = VendingMachine::CommandPanel.new(account: account)

        expect(account).to receive(:reset_balance)

        command_panel.push_button(:cancel)
      end

      it "tells the change dispenser to dispense the change due" do
        change_due = double(:change_due)
        account = double(:account, reset_balance: change_due)
        change_dispenser = double(:change_dispenser)

        command_panel = VendingMachine::CommandPanel.new(
          account: account,
          change_dispenser: change_dispenser,
        )

        expect(change_dispenser).to receive(:dispense_balance).with(change_due)
        command_panel.push_button(:cancel)
      end
    end

    context "not :cancel" do
      it "does not signal the change dispenser" do
        account = double(:account)
        change_dispenser = double(:change_dispenser)

        command_panel = VendingMachine::CommandPanel.new(
          account: account,
          change_dispenser: change_dispenser,
        )

        expect(account).not_to receive(:reset_balance)
        expect(change_dispenser).not_to receive(:dispense_balance)

        command_panel.push_button(:a)
      end
    end
  end
end
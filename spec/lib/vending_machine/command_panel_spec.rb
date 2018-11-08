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

      it "notifies the machine of the attempted purchase" do
        command_panel = VendingMachine::CommandPanel.new
        account = command_panel.account
        inventory = command_panel.inventory

        expect(inventory).to receive(:attempt_purchase)
          .with(:d, 9, account)
          .and_call_original

        command_panel.push_button(:d)
        command_panel.push_button(9)
      end

      it "resets selected row / column" do
        command_panel = VendingMachine::CommandPanel.new

        command_panel.push_button(:d)
        command_panel.push_button(9)

        expect(command_panel.selected_column).to be_nil
        expect(command_panel.selected_row).to be_nil
      end

      it "dispenses any change left from a successful purchase" do
        command_panel = VendingMachine::CommandPanel.new
        inventory = command_panel.inventory
        change_dispenser = command_panel.change_dispenser
        account = command_panel.account

        product = double(:product, name: "CHIPS", price: 1.00)

        inventory.stock_item(:d, 9, product)
        account.add_funds(5)

        expect(change_dispenser).to receive(:dispense_bills).with(4)

        command_panel.push_button(:d)
        command_panel.push_button(9)

        expect(account.balance).to eq(0)
      end

      it "dispenses the item after a successful purchase" do
        command_panel = VendingMachine::CommandPanel.new
        inventory = command_panel.inventory
        change_dispenser = command_panel.change_dispenser
        account = command_panel.account

        product = double(:product, name: "CHIPS", price: 1.00)

        inventory.stock_item(:d, 9, product)
        account.add_funds(5)

        expect {
          command_panel.push_button(:d)
          command_panel.push_button(9)
        }.to change {
          inventory.items[:d][9].count
        }.from(1).to(0)
      end

      it "passes on failed purchase error messages to the display" do
        command_panel = VendingMachine::CommandPanel.new
        inventory = command_panel.inventory
        display = command_panel.display
        account = command_panel.account

        product = double(:product, name: "CHIPS", price: 1.00)

        inventory.stock_item(:d, 9, product)

        expect(display).to receive(:show_message).with("SOLD OUT")
        command_panel.push_button(:d)
        command_panel.push_button(8)

        expect(display).to receive(:show_message).with("MUST ADD $1.00")
        command_panel.push_button(:d)
        command_panel.push_button(9)
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
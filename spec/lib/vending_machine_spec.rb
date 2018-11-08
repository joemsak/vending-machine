require "spec_helper"
require "vending_machine"

RSpec.describe VendingMachine do
  describe ".power_on" do
    it "initializes the account" do
      machine = VendingMachine.power_on
      account = machine.account
      expect(account).to be_a(VendingMachine::Account)
      expect(account.balance).to eq(0)
    end

    it "initializes the inventory" do
      machine = VendingMachine.power_on
      inventory = machine.inventory

      expect(inventory).to be_a(VendingMachine::Inventory)
      expect(inventory.read_section(:a, 0).name).to eq("EMPTY")
    end

    it "initializes the display" do
      machine = VendingMachine.power_on
      expect(machine.display).to be_a(VendingMachine::Display)
    end

    it "initializes the change dispenser" do
      machine = VendingMachine.power_on
      expect(machine.change_dispenser).to be_a(VendingMachine::ChangeDispenser)
    end

    it "initializes the command panel" do
      machine = VendingMachine.power_on
      expect(machine.command_panel).to be_a(VendingMachine::CommandPanel)
    end

    it "initializes the command panel with the components" do
      machine = VendingMachine.power_on

      account = machine.account
      inventory = machine.inventory

      inventory.designate_section(:a, 0, name: "CHIPS", price: 0.10)
      inventory.stock_item(:a, 0)

      machine.command_panel.insert_coins(0.25)
      expect(account.balance).to eq(0.25)

      expect(machine.change_dispenser).to receive(:dispense_coins).with(0.15)
      expect(machine.display).to receive(:show_message).with(
        "THANK YOU, ENJOY! <3 <3 <3"
      )

      machine.command_panel.push_button(:a)
      machine.command_panel.push_button(0)

      expect(inventory.read_section(:a, 0).quantity).to eq(0)
      expect(account.balance).to eq(0)
    end
  end
end
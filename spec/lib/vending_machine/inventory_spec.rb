require 'ostruct'
require "spec_helper"
require "vending_machine/inventory"

RSpec.describe VendingMachine::Inventory do
  describe "#designate_section" do
    it "sets the product name" do
      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS")

      section = inventory.read_section(:a, 0)
      expect(section.name).to eq("CHIPS")
    end

    it "sets the product price" do
      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)

      section = inventory.read_section(:a, 0)
      expect(section.price).to eq(3.00)
    end
  end

  describe "#stock_item" do
    it "stocks one item in the section" do
      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)

      expect {
        inventory.stock_item(:a, 0)
      }.to change {
        inventory.read_section(:a, 0).quantity
      }.from(0).to(1)
    end

    it "stocks no more than 10 items" do
      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)

      10.times { inventory.stock_item(:a, 0) }

      expect {
        inventory.stock_item(:a, 0)
      }.not_to change {
        inventory.read_section(:a, 0).quantity
      }.from(10)
    end
  end

  describe "#restock_items" do
    it "fills the quantity of the given section" do
      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)

      3.times { inventory.stock_item(:a, 0) }

      expect {
        inventory.restock_items(:a, 0)
      }.to change {
        inventory.read_section(:a, 0).quantity
      }.from(3).to(10)
    end
  end

  describe "#attempt_purchase" do
    it "returns a failed purchase for the product being sold out" do
      account = double(:account)
      inventory = VendingMachine::Inventory.new

      purchase = inventory.attempt_purchase(:a, 0, account)

      expect(purchase).not_to be_succeeded
      expect(purchase).to be_failed
      expect(purchase.error).to eq("SOLD OUT")
    end

    it "returns a failed purchase for the account balance being too low" do
      account = double(:account, balance: 2.90)

      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)
      inventory.stock_item(:a, 0)

      purchase = inventory.attempt_purchase(:a, 0, account)

      expect(purchase).not_to be_succeeded
      expect(purchase).to be_failed
      expect(purchase.error).to eq("MUST ADD $0.10")
    end

    it "returns a successful purchase otherwise" do
      account = double(:account, balance: 3.00)

      inventory = VendingMachine::Inventory.new
      inventory.designate_section(:a, 0, name: "CHIPS", price: 3.00)
      inventory.stock_item(:a, 0)

      purchase = inventory.attempt_purchase(:a, 0, account)

      expect(purchase).to be_succeeded
      expect(purchase).not_to be_failed
      expect(purchase.cost).to eq(3)
    end
  end
end
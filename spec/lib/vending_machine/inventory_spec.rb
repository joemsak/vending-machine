require "spec_helper"
require "vending_machine/inventory"

RSpec.describe VendingMachine::Inventory do
  describe "#stock_item" do
    it "adds an item to the given row / column" do
      product = double(:product, name: "CHIPS", price: 3.00)
      product2 = double(:product, name: "CHIPS", price: 3.00)

      inventory = VendingMachine::Inventory.new
      inventory.stock_item(:a, 0, product)
      inventory.stock_item(:a, 0, product2)

      expect(inventory.items[:a][0]).to eq([product, product2])
    end

    it "stops adding items when a given location is full" do
      product = double(:product, name: "CHIPS", price: 3.00)

      inventory = VendingMachine::Inventory.new
      10.times { inventory.stock_item(:a, 0, product) }

      expect {
        inventory.stock_item(:a, 0, product)
      }.not_to change {
        inventory.items[:a][0].count
      }.from(10)
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
      product = double(:product, name: "CHIPS", price: 3.00)

      inventory = VendingMachine::Inventory.new
      inventory.stock_item(:a, 0, product)

      purchase = inventory.attempt_purchase(:a, 0, account)

      expect(purchase).not_to be_succeeded
      expect(purchase).to be_failed
      expect(purchase.error).to eq("MUST ADD 0.10")
    end

    it "returns a successful purchase otherwise" do
      account = double(:account, balance: 3.00)
      product = double(:product, name: "CHIPS", price: 3.00)

      inventory = VendingMachine::Inventory.new
      inventory.stock_item(:a, 0, product)

      purchase = inventory.attempt_purchase(:a, 0, account)

      expect(purchase).to be_succeeded
      expect(purchase).not_to be_failed
      expect(purchase.cost).to eq(3)
    end
  end
end
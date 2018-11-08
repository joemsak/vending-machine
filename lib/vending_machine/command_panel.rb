require "vending_machine/account"
require "vending_machine/change_dispenser"
require "vending_machine/inventory"
require "vending_machine/display"

module VendingMachine
  class CommandPanel
    attr_reader :account, :change_dispenser, :inventory, :display

    attr_accessor :selected_row, :selected_column

    def initialize(account: nil, change_dispenser: nil, inventory: nil, display: nil)
      @account = account || Account.new
      @change_dispenser = change_dispenser || ChangeDispenser.new
      @inventory = inventory || Inventory.new
      @display = display || Display.new
    end

    def push_button(name)
      case String(name)
      when /\Acancel\z/; reset_machine
      when /\A[a-g]\z/;  set_row(name)
      when /\A\d\z/;     maybe_set_column(name)
      end

      handle_selection if selected_row && selected_column
    end

    private
    def handle_selection
      purchase = inventory.attempt_purchase(
        selected_row,
        selected_column,
        account
      )

      if purchase.succeeded?
        handle_successful_purchase(purchase)
      else
        handle_failed_purchase(purchase)
      end
    end

    def handle_successful_purchase(purchase)
      inventory.dispense_item(selected_row, selected_column)
      account.subtract_funds(purchase.cost)
      reset_machine
    end

    def handle_failed_purchase(purchase)
      display.error_message(purchase.error)
      reset_selection
    end

    def reset_selection
      @selected_column = nil
      @selected_row = nil
    end

    def reset_machine
      reset_selection
      change_due = account.reset_balance
      change_dispenser.dispense_balance(change_due)
    end

    def set_row(name)
      @selected_row = name
    end

    def maybe_set_column(name)
      unless selected_row.nil?
        @selected_column = name
      end
    end
  end
end
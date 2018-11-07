require "vending_machine/account"
require "vending_machine/change_dispenser"

module VendingMachine
  class CommandPanel
    attr_reader :account, :change_dispenser

    attr_accessor :selected_row, :selected_column

    def initialize(account: nil, change_dispenser: nil)
      @account = account || Account.new
      @change_dispenser = change_dispenser || ChangeDispenser.new
    end

    def push_button(name)
      case String(name)
      when /\Acancel\z/; cancel_transaction
      when /\A[a-g]\z/;  set_row(name)
      when /\A\d\z/;     maybe_set_column(name)
      end
    end

    private
    def cancel_transaction
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
require "vending_machine/version"

module VendingMachine
  class Error < StandardError; end

  autoload :Inventory,       'vending_machine/inventory'
  autoload :Account,         'vending_machine/account'
  autoload :Display,         'vending_machine/display'
  autoload :ChangeDispenser, 'vending_machine/change_dispenser'
  autoload :CommandPanel,    'vending_machine/command_panel'

  def self.power_on
    Machine.new
  end

  class Machine
    attr_reader :account, :inventory, :change_dispenser, :display, :command_panel

    def initialize
      @account = Account.new
      @inventory = Inventory.new
      @change_dispenser = ChangeDispenser.new
      @display = Display.new

      @command_panel = CommandPanel.new(
        account: account,
        inventory: inventory,
        change_dispenser: change_dispenser,
        display: display
      )
    end
  end
end

module VendingMachine
  class Inventory
    attr_reader :sections

    def initialize
      @sections = {}
    end

    def designate_section(row, column, **options)
      sections[row] ||= {}
      sections[row][column] = Section.new(options)
    end

    def read_section(row, column)
      row = sections[row]

      row && row[column] || Section.new
    end

    def stock_item(row, column)
      read_section(row, column).increment_quantity
    end

    def restock_items(row, column)
      read_section(row, column).fill_quantity
    end

    def dispense_item(row, column)
      section = read_section(row, column)
      section.dispense_product
    end

    def attempt_purchase(row, column, account)
      section = read_section(row, column)

      if section.quantity.zero?
        FailedPurchase.new("SOLD OUT")
      elsif section.price > account.balance
        amount_needed = (section.price - account.balance)
        FailedPurchase.new("MUST ADD $#{sprintf('%.2f', amount_needed)}")
      else
        SuccessfulPurchase.new(section)
      end
    end

    class Section
      attr_reader :name, :price, :quantity

      private
      attr_writer :quantity

      public
      def initialize(**options)
        @name = options.fetch(:name) { "EMPTY" }
        @price = options.fetch(:price) { 0.00 }
        @quantity = 0
      end

      def dispense_product
        self.quantity -= 1
        # command the machine API to drop 1 product
        # into the open compartment
      end

      def increment_quantity
        if quantity < 10
          self.quantity += 1
        else
          false
        end
      end

      def fill_quantity
        while quantity < 10
          self.quantity += 1
        end
      end
    end

    class FailedPurchase
      attr_reader :error

      def initialize(error)
        @error = error
      end

      def succeeded?
        false
      end

      def failed?
        true
      end
    end

    class SuccessfulPurchase
      attr_reader :cost

      def initialize(section)
        @cost = section.price
      end

      def succeeded?
        true
      end

      def failed?
        false
      end
    end
  end
end
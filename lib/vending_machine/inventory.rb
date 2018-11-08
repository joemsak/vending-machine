module VendingMachine
  class Inventory
    attr_reader :items

    def initialize
      @items = {
        a: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
        },
        b: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
        },
        c: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
        },
        d: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
          5 => [],
          6 => [],
          7 => [],
          8 => [],
          9 => [],
        },
        e: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
          5 => [],
          6 => [],
          7 => [],
          8 => [],
          9 => [],
        },
        f: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
        },
        h: {
          0 => [],
          1 => [],
          2 => [],
          3 => [],
          4 => [],
          5 => [],
          6 => [],
          7 => [],
          8 => [],
          9 => [],
        },
      }
    end

    def stock_item(row, column, product)
      if items[row][column].count < 10
        items[row][column].push(product)
      else
        false
      end
    end

    def attempt_purchase(row, column, account)
      item = items[row][column].first

      if !item
        FailedPurchase.new("SOLD OUT")
      elsif item.price > account.balance
        amount_needed = (item.price - account.balance)
        FailedPurchase.new("MUST ADD #{sprintf('%.2f', amount_needed)}")
      else
        SuccessfulPurchase.new(item)
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

      def initialize(item)
        @cost = item.price
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
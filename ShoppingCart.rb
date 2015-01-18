items = {
	"Bananas"		=> {"price" => 10 ,"type" => "fruit"},
	"Orange juice"	=> {"price" => 10 ,"type" => "fruit"},
	"Rice"			=> {"price" => 1  ,"type" => "nofruit"},
	"Vacuum cleaner"=> {"price" => 150,"type" => "houseware"},
	"Anchovies"		=> {"price" => 2  ,"type" => "nofruit"}
}


class ShoppingCart

	def initialize(items)
		# @newItem 		= nil
		@items 			= items
 		@inCart 		= []
 		@totalPrice  	= 0
	 	@qDiscount		= 0
 		@discounts 		= 0
 		newItem
	end

	def newItem
		puts "Add an item:"
		newItemStr = gets.chomp
		newItemStr = newItemStr.capitalize
		if 	@items[newItemStr] 
			Item.new self, newItemStr, @items
		else
			puts "Sorry, we ran out of #{newItemStr}."
			self.newItem
		end
	end

	def addItem(newItem)
		@newItem = newItem
		@inCart.push(newItem)
		time = Time.new
		@newItem.discounts(time.wday)
		evalTotal
		printResult
		self.newItem
	end

	def printResult
		puts "\n"
		for item in @inCart
			if item.label == 'Rice'
 				puts "#{item.label}:\t\t#{item.price}\t- #{item.discount}\t= #{item.totPrice}"
 			else
 				puts "#{item.label}:\t#{item.price}\t- #{item.discount}\t= #{item.totPrice}"
 			end
		end
		puts """
		Items: #{@inCart.length}
		Total Price: #{@totalPrice}
		Discount: #{@discounts}
		Total w/Discounts: #{'%.2f' % (@priceWithDisc - @qDiscount)}
		Q-Discount: #{'%.2f' % @qDiscount}
		Total: #{'%.2f' % (@priceWithDisc - @qDiscount)}
		"""
	end

	def evalTotal
		@totalPrice += @newItem.price
		@discounts  += @newItem.discount
		@priceWithDisc = @totalPrice - @discounts
		makeDiscounts
	end

	def makeDiscounts
		if @inCart.length > 5
			@qDiscount = @priceWithDisc * 0.05
		else 
			@qDiscount = 0
		end
	end

end

class Item
	attr_accessor:label
	attr_accessor:price
	attr_accessor:type
	attr_accessor:discount
	attr_accessor:totPrice

	def initialize(sc,label,items)
		@shoppingCart = sc
		@items 		= items
		@label 		= label
		@price 		= items[@label]["price"]
		@type 		= items[@label]["type"]
		@discount 	= 0
		@totPrice 	= 0
		@shoppingCart.addItem(self)
	end

	def discounts(wday)
		if @type == "fruit" && [0,6].index(wday)
			@discount = @price * 0.1
		elsif @type == "houseware" && @price >= 100
			@discount = @price * 0.05
		end
		@totPrice = @price - @discount
	end

end

shoppingCart = ShoppingCart.new(items)


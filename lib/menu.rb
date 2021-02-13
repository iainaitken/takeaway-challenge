require_relative 'dish'

class Menu
  attr_reader :list
# refactor this - get rid of list attribute

  def initialize(dish_class = Dish)
    @dish_class = dish_class
    @list = []
    load_menu
  end

  def show
    print_menu
  end

  def check(dish)
    @list.each do |item|
      if item.name == dish.downcase
        return :unavailable if item.available == "false"
        return :present
      end
    end
    return :not_on_menu
  end

# need a check method, so we can check availability

  private

# note - new class, MenuFile, so I can isolate and test with a testfile. Inject file into class.
  def load_menu
    file = open_file
    load_file(file)
    close_file(file)
  end

  def open_file
    File.open("./lib/data.csv", 'r')
  end

  def load_file(file)
    file.readlines.each do |line|
      name, price, available = line.chomp.split(',')
      dish = @dish_class.new(name, price, available)
      @list.push(dish)
    end
  end

  def close_file(file)
    file.close
  end

  def print_menu
    @list.each do |dish|
      next if dish.available == "false"
      puts "#{dish.name.capitalize}: £#{dish.price}"
    end
  end
end
require 'logger'

# this class provides methods to parse user input
# and generate the delivery instructions for the pizzas
class PizzaDeliveryInstructions

  attr_accessor :grid_dimensions

  def initialize
    @grid_dimensions = []
    @grid_format_regex = /^(\d+)x(\d+)\s*/
    @coords_regex = /\(\s*\d+\s*,\s*\d+\s*\)/
    @logger = Logger.new File.new('./log/pizza_delivery.log', 'w')
  end

  # Provides a template for calling the parsing and
  # instruction generating methods. Also handles errors that
  # arise from performing those actions.
  def get_delivery_instructions(input)
    begin
    incorrect_input = check_for_incorrect_input(input)

    # return early if there is incorrect input
    if (!incorrect_input.nil? && incorrect_input.gsub(" ", "").length > 0)
      return "Input contained the following incorrect items: #{incorrect_input}"
    else
      parse_grid_data(input)

      coords_numbers = parse_coordinate_data(input)

      generate_delivery_instructions(coords_numbers)
    end

    rescue ArgumentError =>ae
      @logger.error ae.message
      @logger.error ae.backtrace
      "Terminating application, input in incorrect format. Input: #{input}. Check documentation for correct format"
    rescue StandardError =>se
      @logger.error se.message
      @logger.error se.backtrace
      "Terminating application. Error: #{se.message}"
    end
  end

  # strip out grid and coordinate information - anything else is incorrect input
  def check_for_incorrect_input(input_string)
    bad_input = input_string.gsub(@grid_format_regex, "")
    bad_input.gsub!(@coords_regex, "")
  end

  # Converts the grid information from the beginning of the user input
  # into an array and validates that the array contains positive integers
  def parse_grid_data(input_string)
    # pull grid information in the format <integer>x<integer> from the start of the input string
    grid_segment = input_string.match(@grid_format_regex)

    # first check that the grid has matched something
    if grid_segment == nil
      raise ArgumentError, "Unable to find grid settings at start of input string: #{input_string}"
    end

    # assign the grid dimensions
    @grid_dimensions = [grid_segment[1].to_i, grid_segment[2].to_i]

    @logger.info "Grid dimensions are: #{@grid_dimensions}"

    # check here that the grid contains only positive numbers
    @grid_dimensions.each do |a|
      raise ArgumentError, "Invalid grid input: #{a} Only positive integers allowed." unless a >= 0
    end
  end

  # Converts the delivery coordinates part of the input into
  # an array of arrays containing pairs of integers
  def parse_coordinate_data(input_string)
    # extract substrings matching ( int , int ) into an array, ignoring whitespace
    coords_string = input_string.scan(@coords_regex)

    #if nothing matches then return an empty array
    if coords_string == nil
      return []
    end

    # remove the brackets, split the coordinate strings, convert to integers, leave as array of arrays
    coords_array =  coords_string.map do |a|
      b = a.gsub(/[()]/, "")
      c = b.split(/,\s*/)
      x, y = c.map { |x| x.to_i}
    end

    @logger.info coords_array

    # check here that the coordinates in the array don't exceed the grid dimensions ever
    coords_array.each do |a|
      if a[0] > @grid_dimensions[0] || a[0] < 0
        raise ArgumentError, "x-coord exceeds grid size. Destination: #{a} in grid #{@grid_dimensions}"
      end

      if a[1] > @grid_dimensions[1] || a[1] < 0
        raise ArgumentError, "y-coord exceeds grid size. Destination: #{a} in grid #{@grid_dimensions}"
      end
    end
  end

  # this method takes the input delivery coordinates and
  # generates a set of instructions for pizza delivery
  def generate_delivery_instructions(coordinate_array)
    # set start to the origin and instructions to empty before we begin
    instructions = ""
    start_point = [0, 0]

    # generate directions from current point to next
    coordinate_array.each do |x|
      north_south = x[0] -  start_point[0]
      east_west = x[1] - start_point[1]

      if north_south > 0
        instructions += "N" * north_south
      elsif north_south <= 0
        instructions += "S" * (north_south * -1)
      end

      if east_west > 0
        instructions += "E" * east_west
      elsif east_west <= 0
        instructions += "W" * (east_west * -1)
      end

      # drop a pizza each time you reach a delivery point
      instructions += "D"

      # set the start point to the delivery point you've just reached
      start_point = x
    end

    # let user know we couldn't find any valid delivery points
    if coordinate_array == []
      instructions = "There were no valid delivery points found in the input!"
    end

    @logger.info "Delivery instructions are: #{instructions}"
    instructions
  end
end


require 'pizza_delivery_instructions'

RSpec.describe 'delivery' do
  before(:context) do
    @pizza_delivery = PizzaDeliveryInstructions.new
    @good_input = "5x5 (0, 0) (1, 3) (4,4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
    @off_grid_input = "5x5 (0, 0) (1, 3) (4,6) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
    @bad_grid_input = "5x5.3 (0, 0) (1, 3) (4,6) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
    @bad_coords_input = "5x5 (0, 01, 3) (4,6) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
    @origin_input = "5x5 (0, 0) (1, 3)"
    @no_destination_input = "5x5"
    @repeated_location_input = "5x5 (1, 3) (1, 3) (2, 2) (0, 4)"
    @repeated_nonconsecutive_location_input = "5x5 (1, 3) (2, 2) (1, 3) (0, 4)"
    @good_coords_string = "(1, 3) (2, 2) (0, 4)"
    @good_coords = [[0, 0], [1, 3], [4, 4], [4, 2], [4, 2], [0, 1], [3, 2], [2, 3], [4, 1]]
  end

  # Check Input tests
  it 'should have a valid grid block at the start of the input' do
    expect(@pizza_delivery.check_for_incorrect_input(@good_input)).to eq("        ")
  end

  it 'should have a valid grid block at the start of the input' do
    expect(@pizza_delivery.check_for_incorrect_input(@bad_grid_input)).to eq(".3         ")
  end

  it 'should have a valid grid block at the start of the input' do
    expect(@pizza_delivery.check_for_incorrect_input(@bad_coords_input)).to eq("(0, 01, 3)       ")
  end

  # Grid Block tests
  it 'should have a valid grid block at the start of the input' do
    expect(@pizza_delivery.parse_grid_data(@good_input)).to eq([5, 5])
  end

  it "should raise an error if the grid block contains floating point numbers" do
    expect{@pizza_delivery.parse_grid_data("5.3x4.6 (1, 3) (2, 2) (0, 4)")}.to raise_error(ArgumentError)
  end

  it "should raise an error if the grid block contain negative integers" do
    expect{@pizza_delivery.parse_grid_data("-5x-4 (1, 3) (2, 2) (0, 4)")}.to raise_error(ArgumentError)
  end

  it "should raise an error if the grid block does not contain integers" do
    expect{@pizza_delivery.parse_grid_data("fivexfive (1, 3) (2, 2) (0, 4)")}.to raise_error(ArgumentError)
  end

  it 'should raise an error if the grid block is not at the start of the input' do
    expect{@pizza_delivery.parse_grid_data("(1, 3) (2, 2) (0, 4) 5x5")}.to raise_error(ArgumentError)
  end

  # Co-ordinate Array tests
  it 'should produce a coord array for valid input' do
    expect(@pizza_delivery.parse_coordinate_data(@good_coords_string)).to eq([[1, 3], [2, 2], [0, 4]])
  end

  it 'should ignore white space in the input' do
    expect(@pizza_delivery.parse_coordinate_data("(1,  3) (2,2)(0, 4)")).to eq([[1, 3], [2, 2], [0, 4]])
  end

  it 'should produce an empty coord array for empty input' do
    expect(@pizza_delivery.parse_coordinate_data("")).to eq([])
  end

  it 'should raise an error if an x co-ordinate exceeds the grid x-size' do
    @pizza_delivery.grid_dimensions = [5, 4]
    expect{@pizza_delivery.parse_grid_data("(1, 3) (2, 2) (6, 4)")}.to raise_error(ArgumentError)
  end

  it 'should raise an error if an x co-ordinate is negative' do
    @pizza_delivery.grid_dimensions = [5, 4]
    expect{@pizza_delivery.parse_grid_data("(-1, 3) (2, 2) (0, 4)")}.to raise_error(ArgumentError)
  end

  it 'should raise an error if an y co-ordinate exceeds the grid y-size' do
    @pizza_delivery.grid_dimensions = [5, 4]
    expect{@pizza_delivery.parse_grid_data("(1, 5) (2, 2) (0, 4)")}.to raise_error(ArgumentError)
  end

  it 'should raise an error if an x co-ordinate is negative' do
    @pizza_delivery.grid_dimensions = [5, 4]
    expect{@pizza_delivery.parse_grid_data("(1, -3) (2, 2) (6, 4)")}.to raise_error(ArgumentError)
  end

  # Route Generation tests
  it 'should produce a set of instructions for valid input' do
    expect(@pizza_delivery.generate_delivery_instructions(@good_coords)).to eq("DNEEEDNNNEDWWDDSSSSWDNNNEDSEDNNWWD")
  end

  # Pizza Delivery tests
   it 'should produce valid output for valid input' do
     expect(@pizza_delivery.get_delivery_instructions(@good_input)).to eq("DNEEEDNNNEDWWDDSSSSWDNNNEDSEDNNWWD")
   end

   it 'should make a delivery at (0, 0)' do
     expect(@pizza_delivery.get_delivery_instructions(@origin_input)).to eq("DNEEED")
   end

  it 'should make a delivery at the same point twice' do
    expect(@pizza_delivery.get_delivery_instructions(@repeated_location_input)).to eq("NEEEDDNWDSSEED")
  end

  it 'should make a delivery at the same point twice non-consecutively' do
    expect(@pizza_delivery.get_delivery_instructions(@repeated_nonconsecutive_location_input)).to eq("NEEEDNWDSEDSED")
  end

  it 'should make no instructions if there are no delivery points' do
    expect(@pizza_delivery.get_delivery_instructions(@no_destination_input)).to eq("There were no valid delivery points found in the input!")
  end

  it 'should make do generate an error message with off grid delivery locations' do
    expect(@pizza_delivery.get_delivery_instructions(@off_grid_input)).to \
      include("Terminating application, input in incorrect format.")
  end

  it 'should make do generate an error message with bad grid information' do
    expect(@pizza_delivery.get_delivery_instructions(@bad_grid_input)).to \
      include("Input contained the following incorrect items:")
  end

  it 'should make do generate an error message with bad coords information' do
    expect(@pizza_delivery.get_delivery_instructions(@bad_coords_input)).to \
      include("Input contained the following incorrect items:")
  end
end
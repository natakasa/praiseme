require 'rails_helper'

RSpec.describe Line, type: :model do
  it "is valid with char_no, content, line" do
    line = Line.new(char_no: 1, content: "content test", line: "line test")
    expect(line).to be_valid
  end
end

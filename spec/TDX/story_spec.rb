require_solution 'TDX'

describe Story do
  it "Read the beginning of a story" do
    expect(Story.new.read).to eq "Once upon a time"
  end
end

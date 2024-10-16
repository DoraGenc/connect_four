require_relative "../lib/player.rb"

RSpec.describe Player do

  let(:name) { "player1" }
  let(:mark_type) { "O" }
  subject(:player) { described_class.new(name, mark_type) }

  context "when initializing a Player instance" do
    it "has a name" do
      expect(player.name).to eql(name)
    end

    it "has a mark type" do
      expect(player.mark_type).to eql(mark_type)
    end
  end

  context "when trying to change the mark_type or name afterwards" do
    it "the mark_type can not be changed" do
      new_mark_type = "X"
      expect { player.mark_type = new_mark_type }.to raise_error(NoMethodError)
    end

    it "the name can not be changed" do
      new_name = "player three"
      expect { player.mark_type = new_name }.to raise_error(NoMethodError)
    end
  end
end
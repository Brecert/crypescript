require "spec"
require "../src/crypescript"

describe Crypescript::Literals do
  describe "ArrayLiteral" do
    it "is should return an accurate ts array" do
      transpiler = Crypescript
      transpiler.parse("[]").should eq "[]"
    end
  end
end

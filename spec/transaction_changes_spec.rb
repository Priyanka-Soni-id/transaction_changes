require 'spec_helper'

RSpec.describe TransactionChanges do
  it "has a version number" do
    expect(TransactionChanges::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end

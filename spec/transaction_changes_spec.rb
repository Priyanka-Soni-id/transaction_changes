require 'spec_helper'
require 'model/user'

RSpec.describe TransactionChanges do

  let(:user) do
    u = User.new(:name => "Priyanka", :occupation => "Developer")
    u.save!
    u
  end

  before{user}

  it "has a version number" do
    expect(TransactionChanges::VERSION).not_to be nil
  end

  context 'when new user is created' do
    it "when included keep track of attribute changes of a model" do
      test_user = User.new(:name => "Priyanka")
      test_user.save!
      transaction_changes = test_user.all_transaction_changes
      expect(transaction_changes["id"]).to eq([nil, test_user.id])
      expect(transaction_changes["name"]).to eq([nil, "Priyanka"])
    end
  end

  context 'when user model is updated' do
    it "when included keep track of attribute changes of a model" do
      user.name = "PriyankaSoni"
      user.save!
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes["name"]).to eq(["Priyanka", "PriyankaSoni"])
    end
  end

  context 'when double save is there for transaction' do
    it "when included keep track of attribute changes of a model" do
      user.transaction do
        user.name = "PriyankaSoni"
        user.save!
        user.occupation = "Tester"
        user.save!
      end
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes["name"]).to eq(["Priyanka", "PriyankaSoni"])
      expect(transaction_changes["occupation"]).to eq(["Developer", "Tester"])
    end
  end

  context 'when transaction is rollbacked' do
    it "when included keep track of attribute changes of a model" do
      user.transaction do
        user.name = "PriyankaSoni"
        user.save!
        raise ActiveRecord::Rollback
      end
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes["name"]).to eq([nil, "Priyanka"])
    end
  end

  context 'when transaction changes after reload saved' do
    it 'when included keep track of attribute changes of a model' do
      user.transaction do
        user.name = "PriyankaSoni"
        user.save!
        user.reload
      end
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes["name"]).to eq(["Priyanka", "PriyankaSoni"])
    end
  end

  context 'when transaction changes after reload unsaved' do
    it 'when included keep track of attribute changes of a model' do
      user.transaction do
        user.name = "PriyankaSoni"
        user.save!
        user.name = "Soni"
        user.reload
      end
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes["name"]).to eq(["Priyanka", "PriyankaSoni"])
    end
  end

  context 'when there is no change' do
    it 'when included keep track of attribute changes of a model' do
      user.transaction do
        user.name = "Priyanka"
        user.save!
      end
      transaction_changes = user.all_transaction_changes
      expect(transaction_changes).to eq({})
    end
  end
end

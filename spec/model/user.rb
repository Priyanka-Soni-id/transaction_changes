class User < ActiveRecord::Base
  include TransactionChanges

  attr_accessor :all_transaction_changes

  after_commit :transaction_changes_tests

  def transaction_changes_tests
    @all_transaction_changes = transaction_changes
  end
end
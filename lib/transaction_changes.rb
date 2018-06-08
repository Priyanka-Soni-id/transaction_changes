require "transaction_changes/version"

module TransactionChanges
  extend ActiveSupport::Concern

  included do
    after_commit -> { reset_transaction_changes }
    after_save -> { accumulate_changes }
  end

  def transaction_changes
    @old_transaction_changes || HashWithIndifferentAccess.new
  end

  private
  def accumulate_changes
    @new_transaction_changes ||= HashWithIndifferentAccess.new

    self.changes.each do |key, value|
      @new_transaction_changes[key] = value
    end
  end

  def reset_transaction_changes
    @new_transaction_changes, @old_transaction_changes = HashWithIndifferentAccess.new, @new_transaction_changes
  end
end

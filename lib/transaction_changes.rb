require "transaction_changes/version"
require 'active_support/concern'
require "active_support/callbacks"

module TransactionChanges
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks

  included do
    after_save -> { accumulate_changes }
    set_callback :commit, :before, :setting_variables
  end

  def setting_variables
    @new_transaction_changes, @old_transaction_changes = HashWithIndifferentAccess.new, @new_transaction_changes
  end

  def transaction_changes
    @old_transaction_changes || HashWithIndifferentAccess.new
  end

  def _run_rollback_callbacks
    super
  ensure
    @old_transaction_changes = HashWithIndifferentAccess.new
  end

  private

  def accumulate_changes
    @new_transaction_changes ||= HashWithIndifferentAccess.new

    self.saved_changes.each do |key, value|
      @new_transaction_changes[key] = value
    end
  end

end

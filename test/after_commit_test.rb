require File.dirname(__FILE__) + '/test_helper'

class MockRecord < ActiveRecord::Base
  attr_accessor :after_commit_on_create_called
  attr_accessor :after_commit_on_update_called
  attr_accessor :after_commit_on_destroy_called

  after_commit_on_create :do_create
  def do_create
    self.after_commit_on_create_called = true
  end

  after_commit_on_update :do_update
  def do_update
    self.after_commit_on_update_called = true
  end

  after_commit_on_create :do_destroy
  def do_destroy
    self.after_commit_on_destroy_called = true
  end
end

class UnsavableRecord < ActiveRecord::Base
  attr_accessor :after_commit_called

  set_table_name 'mock_records'

  protected

  def after_initialize
    self.after_commit_called = false
  end

  def after_save
    raise
  end

  after_commit :after_commit

  def after_commit
    self.after_commit_called = true
  end
end

class AfterCommitTest < Test::Unit::TestCase
  def test_after_commit_on_create_is_called
    assert_equal true, MockRecord.create!.after_commit_on_create_called
  end

  def test_after_commit_on_update_is_called
    record = MockRecord.create!
    record.save
    assert_equal true, record.after_commit_on_update_called
  end

  def test_after_commit_on_destroy_is_called
    assert_equal true, MockRecord.create!.destroy.after_commit_on_destroy_called
  end

  def test_after_commit_does_not_trigger_when_transaction_rolls_back
    record = UnsavableRecord.new
    begin; record.save; rescue; end

    assert_equal false, record.after_commit_called
  end
end

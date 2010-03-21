require 'test_helper'


class Foo < ActiveRecord::Base
  attr_reader :creating
  
  after_commit :create_bar
  
  private
  
  def create_bar
    @creating ||= 0
    @creating += 1
    
    raise Exception, 'looping' if @creating > 1
    Bar.create
  end
end

class Bar < ActiveRecord::Base
  #
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
  attr_accessor :after_commit_on_create_called

  def after_commit
    self.after_commit_called = true
  end
end

class HazardRecord < ActiveRecord::Base
  attr_accessor :after_rollback_called

  set_table_name 'mock_records'  

  protected
  
  after_commit :do_raise_exception
  
  def do_raise_exception
    raise StandardError, 'hell'
  end    
end


class AfterCommitTest < Test::Unit::TestCase
  
  def test_the_basics
    foo = Foo.create!
    assert_equal 1, foo.creating
  end
  
  def test_two_transactions_are_separate
    Bar.delete_all
    foo = Foo.create
  
    assert_equal 1, foo.creating
  end
  
  def test_after_commit_does_not_trigger_when_transaction_rolls_back
    record = UnsavableRecord.new
    begin; record.save; rescue; end
  
    assert_equal false, record.after_commit_called
  end
  
  def test_after_commit_exception_should_be_propagated_correctly
    record = HazardRecord.new
    
    num = HazardRecord.count

    assert_raise(StandardError) do            
      HazardRecord.transaction { record.save }
    end
    
    assert_equal HazardRecord.count, num+1    
      
  end
  
  
  def test_record_keeping
    
    connection = Struct.new(:old_transaction_key).new('123')
    
    AfterCommit.records(connection) << 1    
    assert_equal Set.new([1]), AfterCommit.records(connection)
  end

  def test_record_cleaning
    connection = Struct.new(:old_transaction_key).new('123')

    AfterCommit.records(connection) << 1    
    AfterCommit.cleanup(connection)
    assert_equal Set.new(), AfterCommit.records(connection)
  end
  
  
end

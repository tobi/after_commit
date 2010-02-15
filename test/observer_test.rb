require 'test_helper'

class ObservableMockRecord < ActiveRecord::Base
  set_table_name 'mock_records'

  attr_accessor :after_commit_called
end

class ObservableMockRecordObserver < ActiveRecord::Observer
  def after_commit(model)
    model.after_commit_called = true
  end
end

class ObserverTest < Test::Unit::TestCase
  def setup
    ObservableMockRecord.add_observer ObservableMockRecordObserver.instance
  end

  def test_after_commit_is_called
    record = ObservableMockRecord.create!

    assert record.after_commit_called
  end

end

module AfterCommit
  def self.committed_records
    Thread.current[:committed_records] ||= []
  end
  
  def self.committed_records=(committed_records)
    Thread.current[:committed_records] = committed_records
  end
  
  def self.committed_records_on_create
    Thread.current[:committed_records_on_create] ||= []
  end
  
  def self.committed_records_on_create=(committed_records)
    Thread.current[:committed_records_on_create] = committed_records
  end
  
  def self.committed_records_on_update
    Thread.current[:committed_records_on_update] ||= []
  end
  
  def self.committed_records_on_update=(committed_records)
    Thread.current[:committed_records_on_update] = committed_records
  end
  
  def self.committed_records_on_destroy
    Thread.current[:committed_records_on_destroy] ||= []
  end
  
  def self.committed_records_on_destroy=(committed_records)
    Thread.current[:committed_records_on_destroy] = committed_records
  end
end

require 'after_commit/active_record'
require 'after_commit/connection_adapters'

ActiveRecord::Base.send(:include, AfterCommit::ActiveRecord)

Object.subclasses_of(ActiveRecord::ConnectionAdapters::AbstractAdapter).each do |klass|
  klass.send(:include, AfterCommit::ConnectionAdapters)
end

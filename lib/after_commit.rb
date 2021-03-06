module AfterCommit
  
  def self.add(connection, record)
    Thread.current[:committed_records] ||= {}
    Thread.current[:committed_records][connection.unique_transaction_key] ||= Set.new
    Thread.current[:committed_records][connection.unique_transaction_key] << record
  end
  
  def self.records(connection)
    Thread.current[:committed_records] ||= {}
    Thread.current[:committed_records][connection.old_transaction_key] ||= Set.new
  end
    
  def self.cleanup(connection)
    Thread.current[:committed_records]  ||= {}
    Thread.current[:committed_records].delete(connection.old_transaction_key)
  end  
end

require 'active_record'
require 'after_commit/callback'
require 'after_commit/connection_adapters'
require 'after_commit/test_bypass'

ActiveRecord::Base.send(:include, AfterCommit::Callback)
ActiveRecord::Base.connection.class.send(:include, AfterCommit::ConnectionAdapters)

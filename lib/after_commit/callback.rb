module AfterCommit
  module Callback
    def self.included(base)
      base.define_callbacks  :after_commit      
      base.after_create  :add_committed_record_on_create
      base.after_update  :add_committed_record_on_update
      base.after_destroy :add_committed_record_on_destroy      
    end
    
    def add_committed_record_on_create
      AfterCommit.record(self.class.connection, self)
      AfterCommit.record_created(self.class.connection, self)
    end
    
    def add_committed_record_on_update
      AfterCommit.record(self.class.connection, self)
      AfterCommit.record_updated(self.class.connection, self)
    end
    
    def add_committed_record_on_destroy
      AfterCommit.record(self.class.connection, self)
      AfterCommit.record_destroyed(self.class.connection, self)
    end        
    
  end
end

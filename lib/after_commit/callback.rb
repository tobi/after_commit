module AfterCommit
  module Callback
    def self.included(base)
      base.define_callbacks  :after_commit      
      base.after_save    :mark_record_for_after_commit
      base.after_destroy :mark_record_for_after_commit
    end
    
    def mark_record_for_after_commit
      AfterCommit.add(self.class.connection, self)
      true
    end
    
  end
end

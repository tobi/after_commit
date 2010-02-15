module AfterCommit
  module ConnectionAdapters
    def self.included(base)
      base.class_eval do
        # The commit_db_transaction method gets called when the outermost
        # transaction finishes and everything inside commits. We want to
        # override it so that after this happens, any records that were saved
        # or destroyed within this transaction now get their after_commit
        # callback fired.
        def commit_db_transaction_with_callback
          increment_transaction_pointer
          result = commit_db_transaction_without_callback
            
          AfterCommit.records(self).each do |record|
            record.send :callback, :after_commit
          end
                    
        ensure
          AfterCommit.cleanup(self)
          decrement_transaction_pointer
          result
        end 
        
        alias_method_chain :commit_db_transaction, :callback
        
        def unique_transaction_key
          [object_id, transaction_pointer]
        end
        
        def old_transaction_key
          [object_id, transaction_pointer - 1]
        end
        
        protected

        
        def transaction_pointer
          Thread.current[:after_commit_pointer] ||= 0
        end
        
        def increment_transaction_pointer
          Thread.current[:after_commit_pointer] ||= 0
          Thread.current[:after_commit_pointer] += 1
        end
        
        def decrement_transaction_pointer
          Thread.current[:after_commit_pointer] ||= 0
          Thread.current[:after_commit_pointer] -= 1
        end
      end 
    end 
  end
end

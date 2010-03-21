# Fix problems caused because tests all run in a single transaction.

# The single transaction means that after_commit callback never happens in tests.  Each of these method definitions
# overwrites the method in the after_commit plugin that stores the callback for after the commit.  In each case here
# we simply call the callback rather than waiting for a commit that will never come.

module AfterCommit::TestBypass
  def mark_record_for_after_commit
    callback :after_commit
  end
end

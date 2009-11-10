require 'after_commit'

ActiveRecord::Base.class_eval do 
  include AfterCommit::ActiveRecord
  include AfterCommit::TestBypass if RAILS_ENV == 'test'
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'test/unit'
require 'rubygems'
require 'activerecord'

begin
  require 'sqlite3'
rescue LoadError
  gem 'sqlite3-ruby'
  retry
end

ActiveRecord::Base.establish_connection({"adapter" => "sqlite3", "database" => 'test.sqlite3'})
begin
  ActiveRecord::Base.connection.execute("drop table mock_records");
rescue
end
ActiveRecord::Base.connection.execute("create table mock_records(id int)");

require 'after_commit'

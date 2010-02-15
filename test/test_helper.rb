$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'test/unit'
require 'rubygems'
require 'active_record'

begin
  require 'sqlite3'
rescue LoadError
  gem 'sqlite3-ruby'
  retry
end

require 'logger'
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection("adapter" => "mysql", "database" => 'mock_records', 'host' => '127.0.0.1', 'username' => 'root', 'password' => '')

begin
  ActiveRecord::Base.connection.execute("DROP TABLE mock_records");
  ActiveRecord::Base.connection.execute("DROP TABLE bars");
  ActiveRecord::Base.connection.execute("DROP TABLE foos");
rescue
end
ActiveRecord::Base.connection.execute("CREATE TABLE `mock_records` (id INT);");
ActiveRecord::Base.connection.execute("CREATE TABLE `bars` (id INT);");
ActiveRecord::Base.connection.execute("CREATE TABLE `foos` (id INT);");

require 'after_commit'

require 'active_record/base'

ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

ActiveRecord::Base.class_eval do
  silence(:stdout) do

    connection.create_table :users, :force => true do |t|
      t.string :name, :email
    end

  end
end

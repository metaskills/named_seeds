ActiveRecord::Base.class_eval do
  silence(:stdout) do

    connection.create_table :users, :force => true do |t|
      t.string :name, :email
    end

  end
end

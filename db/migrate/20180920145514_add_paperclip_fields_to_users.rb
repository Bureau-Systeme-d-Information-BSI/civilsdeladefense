class AddPaperclipFieldsToUsers < ActiveRecord::Migration[5.2]
  def up
    User::FILES.each do |file|
      add_attachment :users, file.to_sym
    end
  end

  def down
    User::FILES.each do |file|
      remove_attachment :users, file.to_sym
    end
  end
end

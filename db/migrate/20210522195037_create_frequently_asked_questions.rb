class CreateFrequentlyAskedQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :frequently_asked_questions, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.string :value

      t.timestamps
    end
  end
end

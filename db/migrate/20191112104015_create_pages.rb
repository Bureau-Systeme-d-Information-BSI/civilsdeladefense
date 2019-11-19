# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages, id: :uuid do |t|
      t.string :title
      t.string :slug, uniq: true
      t.boolean :only_link, null: false, default: false
      t.uuid :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth
      t.integer :children_count, null: false, default: 0
      t.text :body
      t.string :url
      t.string :og_title
      t.string :og_description
      t.references :organization, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

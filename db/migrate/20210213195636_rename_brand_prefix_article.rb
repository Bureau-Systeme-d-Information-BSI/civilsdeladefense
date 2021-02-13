# frozen_string_literal: true

class RenameBrandPrefixArticle < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :brand_prefix_article, :prefix_article
  end
end

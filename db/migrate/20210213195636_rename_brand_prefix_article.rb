# frozen_string_literal: true

class RenameBrandPrefixArticle < ActiveRecord::Migration[6.1]
  def change
    # There is no brand_prefix_article ?!
    # rename_column :organizations, :brand_prefix_article, :prefix_article
  end
end

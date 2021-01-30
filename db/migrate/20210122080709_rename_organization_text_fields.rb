# frozen_string_literal: true

class RenameOrganizationTextFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :business_owner_name, :business_owner_name
    add_column :organizations, :description, :string, after: :name
    add_column :organizations, :description_short, :string, after: :name
    add_column :organizations, :business_owner_prefix_article, :string, after: :business_owner_name

    Organization.all.each do |organization|
      business_owner_name = organization.business_owner_name
      regex = /(le|la|l')/i
      next unless business_owner_name.starts_with?(regex)

      ary = business_owner_name.split(regex)
      business_owner_prefix_article = ary[1]
      business_owner_name = ary[2].strip.split(' ', 2).join("\n")
      hsh = {
        business_owner_name: business_owner_name,
        business_owner_prefix_article: business_owner_prefix_article
      }
      organization.update_columns(hsh)
    end
  end
end

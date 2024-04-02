# ransack has not been updated to work with 7.1 as of yet. Version 4.0.0 docs state:
#     Ransack is supported for Rails 7.0, 6.1 on Ruby 2.7 and later.
# Your issue in particular is this one line:
#     table = attr.arel_attribute.relation.table_name
# attr.arel_attribute.relation will return an Arel::Table.
# In Rails 7.0 and prior Arel::Table#table_name was an alias for Arel::Table#name;
# however in 7.1 this was removed because the method is never used in the rails code base.
#
# Here we monkey patch Arel::Table to put the alias back in.
#
# https://stackoverflow.com/a/77180853/12437303
module Arel
  class Table
    alias_method :table_name, :name
  end
end

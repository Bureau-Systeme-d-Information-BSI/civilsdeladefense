module CategoriesHelper
  def categories_options_for_select(selected = nil) = options_for_select(category_options, selected)

  private

  def category_options
    options = []
    Category.roots.each { |category| add_options_for_category(options, category, 0) }
    options
  end

  def add_options_for_category(options, category, level)
    if category.children.any?
      options << [category.name_with_depth, category.id, {disabled: category.children.any?}]
      category.children.each { |child| add_options_for_category(options, child, level + 1) }
    else
      options << [category.name_with_depth, category.id]
    end
  end
end

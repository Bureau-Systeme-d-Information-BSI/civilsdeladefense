module ProfilesHelper
  def gender_options_for_select = enum_options_for_select(Profile, :gender)
end

# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class Admin::Settings::FrequentlyAskedQuestionsController < Admin::Settings::InheritedResourcesController
  def permitted_fields
    %i[name value]
  end
end
# rubocop:enable Layout/LineLength

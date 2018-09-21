class MandatoryFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.job_offer.send("mandatory_option_#{attribute}?") && !value.exists?
      record.errors.add(attribute, :mandatory_file)
    end
  end
end

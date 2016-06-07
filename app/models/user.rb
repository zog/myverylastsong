class User < ActiveRecord::Base
  before_save do
    unless read_attribute :uuid
      write_attribute :uuid, UUIDTools::UUID.timestamp_create.to_s
    end
  end

  def name
    "#{first_name.try :capitalize} #{last_name.try :upcase}"
  end

  def pronoun
    gender.present? ? (gender == "male" ? 'his' : 'her') : 'their'
  end
end

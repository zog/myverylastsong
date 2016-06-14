class User < ActiveRecord::Base
  before_save do
    unless read_attribute :uuid
      write_attribute :uuid, SecureRandom.hex(6)
    end
  end

  def name
    "#{first_name.try :capitalize} #{last_name.try :upcase}"
  end

  def pronoun
    gender.present? ? (gender == "male" ? 'his' : 'her') : 'their'
  end
end

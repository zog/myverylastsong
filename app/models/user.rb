class User < ActiveRecord::Base
  def name
    "#{first_name.try :capitalize} #{last_name.try :upcase}"
  end

  def pronoun
    gender.present? ? (gender == "male" ? 'his' : 'her') : 'their'
  end
end

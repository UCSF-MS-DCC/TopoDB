class User < ApplicationRecord
  has_paper_trail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_admin?
    self.admin == true
  end

  def is_editor?
    self.editor == true
  end
end

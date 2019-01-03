# coding: utf-8
class Task < ApplicationRecord
  #before_validation :set_nameless_name コールバックを試した
  
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate  :validate_name_not_including_comma

  belongs_to :user

  private

  # コールバック関数
  #def set_nameless_name
  #  self.name = '名前なし' if name.blank?
  #end

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end

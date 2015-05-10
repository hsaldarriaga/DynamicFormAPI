class Procedure < ActiveRecord::Base
	has_many :steps
	belongs_to :group
	validates :procedure_id, presence: true, uniqueness: true
	validates :group_id, presence: true
	validates :name, presence: true
	validates :description, presence: true
end

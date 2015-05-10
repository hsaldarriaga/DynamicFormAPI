class Step < ActiveRecord::Base
	belongs_to :procedure
	validates :step_id, presence: true
	validates :procedure_id, presence: true
	validates :content, presence: true
end

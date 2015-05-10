class Group < ActiveRecord::Base
	has_many :procedures
	validates :group_id, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
end

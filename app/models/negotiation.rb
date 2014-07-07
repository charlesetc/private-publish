# == Schema Information
#
# Table name: negotiations
#
#  id            :integer          not null, primary key
#  secure_key    :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  scenario_id   :integer
#  first_user_id :integer
#

class Negotiation < ActiveRecord::Base
  attr_accessible :secure_key, :scenario_id
	
	validates :secure_key, presence: true, uniqueness: true
	validates :scenario_id, presence: true
	
	belongs_to :scenario
	has_many :messages
	
	def full?
		self.users.count >= 2 # This is what designates negotiation size 
	end
	
	def users
		list = []
		User.all.each do |user|
			unless user.admin # Ignore admin's secure keys
				list << user if user.secure_key == self.secure_key
			end
		end
		list
	end
	
	def receiver(current_user)
		self.users.each do |user|
			unless user == current_user
				return user
			end
		end
		false
	end
	
	def first_user=(user)
		if user
			self.first_user_id = user.id
		else
			self.first_user_id = nil
		end
		self.save!
	end
	
	def randomize_first_user
		self.first_user = self.users.shuffle.first
	end
	
	def randomize_if_new
		unless self.first_user
			randomize_first_user
		end
	end
	
	def ready?
		self.full? && self.first_user
	end
	
	def first_user
		User.find_by_id(self.first_user_id)
	end
	
	def language
		self.scenario.language
	end
	
end

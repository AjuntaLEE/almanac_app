class Vacation < ActiveRecord::Base
	validates :name, :presence => true,:length => { :within => 2..5 }
	validates :hourlist, :presence => true, 
									:length => { :within => 48..48 }
	
end

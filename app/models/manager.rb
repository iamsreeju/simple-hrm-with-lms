class Manager < ActiveRecord::Base
  belongs_to :user
  belongs_to :manager, :class_name => "User", :foreign_key => "manager_id"
  attr_accessible :user_id, :manager_id
end

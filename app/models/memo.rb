class Memo < ActiveRecord::Base
  belongs_to :user, :conditions => ['id != ?', 1]
  belongs_to :manager_created, :class_name => "User", :foreign_key => "created_by"
  belongs_to :manager_updated, :class_name => "User", :foreign_key => "updated_by"
  
  attr_accessible :manager_id, :user_id, :created_by, 
  :updated_by, :action_taken, :message, :response, :title

  before_create :set_created_by
  before_save :set_updated_by

  validates_presence_of :user, :title, :message

  attr_accessor :manager_id

  def set_created_by
  		self.created_by = manager_id
  end

  def set_updated_by
  		self.updated_by = manager_id
  end
end

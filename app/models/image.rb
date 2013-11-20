class Image < ActiveRecord::Base
  	attr_accessible :image_active, :image_content_type, :image_file_name, 
  	:image_file_size, :imageable_id, :imageable_type, :image

  	belongs_to :imageable, :polymorphic => true

  	has_attached_file :image, :path => ":style/:id_:filename",
  	:storage => :dropbox,
  	:dropbox_credentials => Rails.root.join("config/dropbox.yml"),
  	:dropbox_options => {environment: ENV["RACK_ENV"]}

	# validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
	validates_presence_of :image
end

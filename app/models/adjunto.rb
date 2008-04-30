class Adjunto < ActiveRecord::Base
	belongs_to :ticket
  acts_as_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain', 'application/vnd.ms-excel', 'application/vnd.oasis.opendocument.text', 'application/vnd.oasis.opendocument.spreadsheet'], 
  									 :max_size => 1.megabyte
  validates_as_attachment

end

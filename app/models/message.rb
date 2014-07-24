class Message
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  def as_json(options={})
    attrs = super(options)
    attrs["id"] = attrs["_id"]
    attrs
  end

  attr_accessible :message, :user_from, :user_to, :image, :is_read

  has_mongoid_attached_file :image,
                            :styles => {
                                :small    => ['65x65#',   :jpg],
                                :large    => ['500x500>',   :jpg]
                            }, :convert_options => { :all => '-background white -flatten +matte' }

  validates :message, presence: true
  validates :user_to, presence: true

  field :message,   :type => String, :default => ""
  field :user_from, :type => String, :default => 0
  field :user_to,   :type => String, :default => 0
  field :image,     :type => String, :default => ""
  field :is_read,   :type => Boolean, :default => false


  belongs_to :to_user, :class_name => 'User', :inverse_of => :recieved_messages, :foreign_key => :user_to
  belongs_to :from_user, :class_name => 'User', :inverse_of => :sent_messages, :foreign_key => :user_from
end
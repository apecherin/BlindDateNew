class User
  include Mongoid::Document
  include Mongoid::Paperclip
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :nickname, :current_password, :password,
                  :password_confirmation, :remember_me, :avatar,
                  :age, :sex, :description

  has_mongoid_attached_file :avatar,
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['65x65#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
    }, :convert_options => { :all => '-background white -flatten +matte' }

  validates :email, presence: true
  validates :description, length: { maximum: 3500 }

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :nickname,              :type => String, :default => ""
  field :avatar,              :type => String, :default => ""
  field :age,              :type => String, :default => ""
  field :sex,              :type => String, :default => ""
  field :description,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :current_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String


  has_many :recieved_messages, :class_name => 'Message', :inverse_of => :to_user, :foreign_key => :user_to
  has_many :sent_messages, :class_name => 'Message', :inverse_of => :from_user, :foreign_key => :user_from
end

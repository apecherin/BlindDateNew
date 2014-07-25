class User
  include Mongoid::Document
  include Mongoid::Paperclip
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_mongoid_attached_file :avatar,
    styles: {
      original: ['1920x1680>', :jpg],
      small: ['65x65#', :jpg],
      mega_small: ['40x40#', :jpg],
      medium: ['250x250', :jpg],
      large: ['500x500>', :jpg]
    },
    convert_options: { all: '-background white -flatten +matte' },
    default_url: lambda { |avatar| avatar.instance.set_default_url}

  validates :nickname, :email, presence: true, uniqueness: true
  validates :description, length: { maximum: 3500 }
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  has_many :recieved_messages, class_name: 'Message', inverse_of: :to_user, foreign_key: :user_to
  has_many :sent_messages, class_name: 'Message', inverse_of: :from_user, foreign_key: :user_from

  # def self.find(input)
  #   input.class == 'BSON::ObjectId' ? find_by(id: input) : find_by(nickname: input)
  # end
  #
  # def to_param
  #   nickname
  # end

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :nickname,           type: String, default: ""
  field :avatar,             type: String, default: ""
  field :age,                type: Integer, default: 0
  field :sex,                type: Integer, default: 0 #man
  field :description,        type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :current_password,   type: String, default: ""
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  ## Rememberable
  field :remember_created_at, type: Time
  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String


  def set_default_url
    sex = self.sex == 0 ? 'male' : 'female'
    ActionController::Base.helpers.asset_path("avatars/#{sex}/default.png")
  end

end

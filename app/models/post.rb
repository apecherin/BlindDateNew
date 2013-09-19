class Post
  include Mongoid::Document
  field :id, type: String
  field :title, type: String
  field :content, type: String
end

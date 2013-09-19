class BlindDateNew.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null

class BlindDateNew.Collections.PostsCollection extends Backbone.Collection
  model: BlindDateNew.Models.Post
  url: '/posts'

class BlindDateNew.Models.Message extends Backbone.Model
  paramRoot: 'message'

  defaults:
    message: null
    user_to: null
    user_from: null
    image: null
    date_at: null

class BlindDateNew.Collections.MessagesCollection extends Backbone.Collection
  model: BlindDateNew.Models.Message
  url: '/messages'

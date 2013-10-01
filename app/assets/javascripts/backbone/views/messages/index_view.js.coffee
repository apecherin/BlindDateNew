BlindDateNew.Views.Messages ||= {}

class BlindDateNew.Views.Messages.IndexView extends Backbone.View
  template: JST["backbone/templates/messages/index"]

  initialize: () ->
    @options.messages.bind('reset', @addAll)

  addAll: () =>
    @options.messages.each(@addOne)

  addOne: (message) =>
    view = new BlindDateNew.Views.Messages.MessageView({model : message})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(messages: @options.messages.toJSON() ))
    @addAll()

    return this

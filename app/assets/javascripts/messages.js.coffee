dialog =
  init: ->
    @modalInit()

  modalInit: ->
    $('#messages .mess').click (e) ->
      e.preventDefault()
      dialog.getMessages($(@).data('id'))

  getMessages: (id) ->
    $.ajax
      url: "/messages/getDialog"
      type: "POST"
      data:
        id: id
      dataType: "json"
      success: (res) ->
        $.each res.messages, (key, message) ->
          $('#messages').append('<li>'+message.user_from.nickname+' '+message.message+' '+message.created_at+'</li>')
        $('#myModal').modal('show')

dialog2 =
  init: ->
    @modalInit()

  modalInit: ->
    $('#messages .mess').click ->
      window.location = $(this).attr("href")

chat_private =
  init: ->
    if document.getElementById("chat_room_private")
      window.client = new Faye.Client("http://localhost:9292/faye")
      @fayePrivInit()
      @updateScroll_new()
      do @newMessage

  fayePrivInit: ->
    private_subscription = client.subscribe("/messages/private/" + user_id, (data) ->
      tr = $("<tr></tr>")
      res = tr.html(data.td_img + data.td_nick_date + data.td_mess)
      res.appendTo ".table"
      chat_private.updateScroll_new 300
      )

  updateScroll_new: (down = 0) ->
    scrollinDiv = document.getElementById("chat_room_private")
    scrollinDiv.scrollTop = Math.pow(100, 10) + down

  newMessage: ->
    $('#new_message_form_private #send').click (e) ->
      e.preventDefault()
      chat_private.addMessage()

  addMessage: () ->
    #protection xss by underscore
    message = _.escape($("#message").val())
    $.ajax
      url: "/messages/addMessage"
      type: "POST"
      data:
      #push message to DB
        message:
          message: message
          user_to: $('#user_to').val()
          user_from: $('#user_from').val()
      success: (res) ->
        if res.success
          td_img = "<td><div id=\"img\">" + avatar + "</div></td>"
          td_nick_date = "<td><div id=\"nickname\">" + nickname + "</div><div id=\"date\">" + cur_time + "</div></td>"
          td_mess = "<td><div id=\"text\">" + message + "</div></td>"
          #push message to patner
          client.publish "/messages/private/" + $("#user_to").val(),
            td_img: td_img
            td_nick_date: td_nick_date
            td_mess: td_mess
          tr = $("<tr></tr>")
          result = tr.html(td_img + td_nick_date + td_mess)
          #push to our win
          result.appendTo ".table"
          $("#message").val ""
          chat_private.updateScroll_new 300

chat =
  init: ->
    if document.getElementById("chat_room")
      window.client = new Faye.Client("http://localhost:9292/faye")
      @fayePubInit()
      @updateScroll()
      do @newMessage

  fayePubInit: ->
    public_subscription = client.subscribe("/messages/public", (data) ->
      p = $("<p></p>")
      result = p.html(data.nick_date + ": " + data.mess)
      #push to our win
      result.appendTo "#chat_room"
      chat.updateScroll 300
    )

  updateScroll: (down = 0) ->
    scrollinDiv = document.getElementById("chat_room")
    scrollinDiv.scrollTop = Math.pow(100, 10) + down

  newMessage: ->
    $('#new_message_form').submit (e) ->
      e.preventDefault()
      chat.addMessage()

  addMessage: () ->
    #protection xss by underscore
    message = _.escape($("#message").val())
    if message
      #push message to patners
      client.publish "/messages/public",
        nick_date: cur_time + " " + nickname
        mess: message
      $("#message").val ""
      chat.updateScroll 300

$ ->
  dialog2.init()
  chat_private.init()
  chat.init()
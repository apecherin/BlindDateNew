messages =
  init: ->
    @countMess()
  read: ->
    @readMess()

  countMess: ->
    $.ajax
      url: "/messages/countMessage"
      type: "POST"
      data:
        id:  user_id
      dataType: "json"
      success: (res) ->
        $("#messages_link").html("Почта \+" + res.count) if res.count > 0
        $("#messages_link_main").html("Почта \+" + res.count) if res.count > 0

  readMess: (id) ->
    $.ajax
      url: "/messages/readMessage"
      type: "POST"
      data:
        id:  id
      dataType: "json"
      success: (res) ->
        console.log res.status

dialog2 =
  init: ->
    @modalInit()

  modalInit: ->
    $('#messages .mess').click ->
      window.location = $(this).attr("href")
    $('.well #user').click ->
      window.location = $(this).attr("href")

chat_private =
  init: ->
    window.client = new Faye.Client("http://localhost:9292/faye")
    @fayePrivInit()
    do @newMessage
    if document.getElementById("chat_room_private")
      @updateScroll_new()

  fayePrivInit: ->
    private_subscription = client.subscribe("/messages/private/" + user_id, (data) ->
      tr = $("<tr></tr>")
      res = tr.html(data.td_img + data.td_nick_date + data.td_mess)
      if document.getElementById("chat_room_private") && data.user_from == $('#user_to').val()
        res.appendTo ".table"
        chat_private.updateScroll_new 300
        messages.readMess(data.mess_id)
      messages.init()
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
          td_img = "<td class=\"avat\"><div id=\"img\">" + avatar + "</div></td>"
          td_nick_date = "<td><div id=\"nickname\">" + nickname + "</div><div id=\"date\">" + cur_time + "</div></td>"
          td_mess = "<td class=\"text_mess\">" + message + "</td>"
          #push message to patner
          client.publish "/messages/private/" + $("#user_to").val(),
            td_img: td_img
            td_nick_date: td_nick_date
            td_mess: td_mess,
            mess_id: res.mess_id,
            user_from: $('#user_from').val()
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
  messages.init()
count_messages =
  init: ->
    console.log '1'
   # if document.getElementById("messages_link")
    console.log '1'
    @countMess()

  countMess: ->
    $.ajax
      url: "/messages/countMessage"
      type: "POST"
      data:
        id:  user_id
      dataType: "json"
      success: (res) ->
        $("#messages_link").html("Почта \+" + res.count) if res.count > 0

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
$ ->
  count_messages.init()

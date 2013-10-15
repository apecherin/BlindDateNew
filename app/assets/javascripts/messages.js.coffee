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
    window.client = new Faye.Client("http://localhost:9292/faye")
    @fayeInit()
    @updateScroll_new()
    do @newMessage

  fayeInit: ->
    private_subscription = client.subscribe("/messages/private/" + user_id, (data) ->
      tr = $("<tr></tr>")
      res = tr.html(data.td_img + data.td_nick_date + data.td_mess)
      res.appendTo ".table"
      )

  updateScroll_new: (down = 0) ->
    scrollinDiv = document.getElementById("chat_room_private")
    scrollinDiv.scrollTop = Math.pow(100, 10) + down

  newMessage: ->
    $('#new_message_form_private #send').click (e) ->
      e.preventDefault()
      chat_private.addMessage()


  addMessage: () ->
    $.ajax
      url: "/messages/addMessage"
      type: "POST"
      data:
        message:
          message: $('#message').val()
          user_to: $('#user_to').val()
          user_from: $('#user_from').val()
      success: (res) ->
        message = $("#message").val()
        td_img = "<td><div id=\"img\">" + avatar + "</div></td>"
        td_nick_date = "<td><div id=\"nickname\">" + nickname + "</div><div id=\"date\">" + cur_time + "</div></td>"
        td_mess = "<td><div id=\"text\">" + message + "</div></td>"
        client.publish "/messages/private/" + $("#user_to").val(),
          td_img: td_img
          td_nick_date: td_nick_date
          td_mess: td_mess

        tr = $("<tr></tr>")
        result = tr.html(td_img + td_nick_date + td_mess)
        result.appendTo ".table"
        $("#message").val ""
        chat_private.updateScroll_new 300

$ ->
  dialog2.init()
  chat_private.init()
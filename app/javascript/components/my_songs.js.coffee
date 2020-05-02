require('jquery')
require('jquery-ui')

window.MySongs = class
  constructor: (container, @userData)->
    @userID = @userData.userId
    @container = $(container)
    @loaded = false
    @loadSongs()

    @newSong = @container.find("#new_song form")
    @newSongInput = @newSong.find("input[type=text]")

    $('.my-link').show().attr('href', $('.my-link').attr('href') + @userID)
    $('.my-link').html $('.my-link').attr('href')
    $('.fb-share').attr 'src', $('.fb-share').attr('src') + @userID
    $('.logged').show()
    $('.unlogged').hide()
    $('.user-first-name').html @userData.firstName
    $('.user-last-name').html @userData.lastName

    @newSong.submit (e)=>
      val = @newSongInput.val()
      $.ajax
        url: '/search?q=' + val
        success: (data)=>
          @displayResults data
      e.preventDefault()

  setAvatar: (url)->
    $('.logo .avatar').attr 'src', url
    setTimeout =>
      $('.logo .avatar').addClass 'visible'
      $('.logo .avatar-skull').removeClass 'visible'
      @spinDisk()
    , 10

  displayResults: (data)->
    @resultsContainer ?= @container.find('.results')
    @resetResults()
    tpl = @resultsContainer.find('.template')
    if data.length > 0
      for item in data
        out = tpl.clone()
        out.removeClass 'template'
        @applyData item, out
        out.appendTo @resultsContainer
        out.data 'data', item
    else
      @resultsContainer.find('.no-results').show()
    @initResultsBehaviours()

  applyData: (data, container)->
    for item in container.find("[data-attr]")
      if $(item).data('loop')?
        tpl = $($(item).html())
        $(item).html(' ')
        out = tpl.clone()
        for d in data[$(item).data('attr')]
          @applyData d, out
          out.appendTo $(item)
      else
        value = data
        chain = $(item).data('attr').split(".")
        for k in chain
          value = value[k]

        if $(item).data('target')
          $(item).attr $(item).data('target'), value
        else if $(item).is "input"
          $(item).val value
        else
          $(item).html value

  appendSong: (data)->
    @songsContainer ?= @container.find('#songs .songs')
    @noSong ?= @songsContainer.find('.no-songs')
    @noSong.hide()
    tpl = @songsContainer.find('.template')
    out = tpl.clone()
    out.removeClass 'template'
    if @loaded
      out.addClass 'hidden'
      out.addClass 'behind'
      @spinDisk()

    @applyData data, out
    out.appendTo @songsContainer
    out.data 'data', data
    out.find("a.delete").click (e)=>
      @removeSong $(e.target).parents('.song')
      e.preventDefault()
      false
    $("ol.songs").sortable
      placeholder: "ui-state-highlight"
      stop: =>
        @saveSequence()
    setTimeout =>
      out.removeClass 'hidden'
    , 100
    setTimeout =>
      out.removeClass 'behind'
    , 1100
    if @loaded
      @saveSequence()

  spinDisk: ->
    $(".logo .disk-container").addClass "spinning"
    setTimeout ->
      $(".logo .disk-container").removeClass "spinning"
    , 500

  scratchDisk: ->
    $(".logo .disk-container").addClass "scratch"
    setTimeout ->
      $(".logo .disk-container").removeClass "scratch"
    , 500

  songItems: ->
    @songsContainer.find('.song:not(.template):not(.no-songs)')

  removeSong: (tgt)->
    data = tgt.data('data')
    $.ajax
      method: "delete"
      url: "/songs/#{data.id}"
      success: =>
        tgt.remove()
        @scratchDisk()
        if @songItems().length == 0
          @noSong.show()

  saveSequence: ->
    seq = []
    for s in @songItems()
      seq.push $(s).data("data")["id"]

    $.ajax
      method: "patch"
      url: "/songs/update_sequence"
      data: {sequence: seq}

  resetResults: ->
    @resultsContainer.find('.result:not(.template)').remove()
    @resultsContainer.find('.no-results').hide()

  loadSongs: ->
    $.ajax
      url: '/songs.json?user_id=' + @userID
      format: 'json'
      success: (data)=>
        for s in data
          @appendSong s
        @loaded = true

  addSong: (data)->
    console.log(data)
    data["userID"] = @userID
    $.ajax
      method: 'post'
      url: '/songs'
      data: {song: data}
      success: =>
        @appendSong data
        @newSongInput.val("")
        @resetResults()

  initResultsBehaviours: ->
    @resultsContainer.find('.add-song').click (e)=>
      res = $(e.target).parents('.result')
      e.preventDefault()
      @addSong res.data('data')
      false

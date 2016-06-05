window.MySongs = class
  constructor: (container, @userID)->
    @container = $(container)
    @loaded = false
    @loadSongs()
    @newSong = @container.find("#new_song")
    @newSongInput = @newSong.find("input[type=text]")
    $('#myLink').show().attr('href', $('#myLink').attr('href') + @userID)
    $('#myLink').html $('#myLink').attr('href')
    $('.share iframe').attr 'src', $('.share iframe').attr('src') + @userID
    $('.logged').show()
    $('.unlogged').hide()
    @newSong.submit (e)=>
      val = @newSongInput.val()
      $.ajax
        url: '/search?q=' + val
        success: (data)=>
          @displayResults data
      e.preventDefault()

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
    @songsContainer ?= @container.find('.songs')
    tpl = @songsContainer.find('.template')
    out = tpl.clone()
    out.removeClass 'template'
    if @loaded
      out.addClass 'hidden'
      out.addClass 'behind'
    @applyData data, out
    out.appendTo @songsContainer
    out.data 'data', data
    out.find("a.delete").click (e)=>
      @removeSong $(e.target).parents('.song')
      e.preventDefault()
      false
    $(".songs").sortable
      placeholder: "ui-state-highlight"
      stop: =>
        @saveSequence()
    setTimeout =>
      out.removeClass 'hidden'
    , 100
    setTimeout =>
      out.removeClass 'behind'
    , 1100
    @saveSequence()

  removeSong: (tgt)->
    data = tgt.data('data')
    $.ajax
      method: "delete"
      url: "/songs/#{data.id}"
      success: ->
        tgt.remove()

  saveSequence: ->
    seq = []
    for s in @songsContainer.find('.song:not(.template)')
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
    data["userID"] = @userID
    $.ajax
      method: 'post'
      url: '/songs'
      data: {song: data}
      success: =>
        console.log 'added'
        @appendSong data
        @newSongInput.val("")
        @resetResults()

  initResultsBehaviours: ->
    @resultsContainer.find('.add-song').click (e)=>
      res = $(e.target).parents('.result')
      e.preventDefault()
      @addSong res.data('data')
      false

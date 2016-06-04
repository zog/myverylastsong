window.MySongs = class
  constructor: (container, @userID)->
    @container = $(container)
    @container.show()
    @loadSongs()
    @newSong = @container.find("#new_song")
    @newSong.show()
    @newSongInput = @newSong.find("input[type=text]")
    $('#myLink').show().attr('href', $('#myLink').attr('href') + @userID)
    $('#myLink').html $('#myLink').attr('href')
    $('.share iframe').attr 'src', $('.share iframe').attr('src') + @userID
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
    for item in data
      out = tpl.clone()
      out.removeClass 'template'
      @applyData item, out
      out.appendTo @resultsContainer
      out.data 'data', item
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
        if $(item).is "input"
          $(item).val data[$(item).data('attr')]
        else
          $(item).html data[$(item).data('attr')]

  appendSong: (data)->
    @songsContainer ?= @container.find('.songs')
    tpl = @songsContainer.find('.template')
    out = tpl.clone()
    out.removeClass 'template'
    @applyData data, out
    out.appendTo @songsContainer
    out.data 'data', data

  resetResults: ->
    @resultsContainer.find('.result:not(.template)').remove()

  loadSongs: ->
    $.ajax
      url: '/songs.json?user_id=' + @userID
      format: 'json'
      success: (data)=>
        for s in data
          console.log s
          @appendSong s

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

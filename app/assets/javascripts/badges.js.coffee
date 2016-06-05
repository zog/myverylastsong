$ ->
    $('.fetch-itunes-link').each (i, a)->
      $a = $(a)
      id = $a.data("id")
      $.ajax
        method: 'get'
        url: "/songs/#{id}/itunes_link"
        success: (data)->
          $a.removeClass 'fetch-itunes-link'
          $a.attr 'href', data.itunes_link

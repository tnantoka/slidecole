# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.ajaxSetup(cache: false)

$(->

  if $('body.slides.show').length 

    $('.js_comment_form').on('ajax:success', (e, data, status, xhr) ->
      $(data).hide().appendTo('.js_comment_list').fadeIn('fast')
      $('.js_comment').val('')
    ).on('ajax:error', (e, xhr, status, error) ->
      #console.error(e)
    )

  if $('body.slides.new').length ||
     $('body.slides.create').length ||
     $('body.slides.edit').length ||
     $('body.slides.update').length

    # affix
    $('.js_page_nav').affix(
      offset: 
        top: 74 
    )
    $(document.body).scrollspy(
      target: '.js_page_nav'
      offset: 74
    )

    # confirm move
    $(window).on('beforeunload', ->
      return ' '
    ) 
    $('form').on('submit', ->
      $(window).off('beforeunload');
      return true
    )
    $('.js_delete_btn').on('click', ->
      $(window).off('beforeunload');
      return true
    )

    # backbone
    pageList = new PageList(gon.pages)

    slideFormView = new SlideFormView(
      el: $('.js_slide')
      collection: pageList
    ).render()

    Backbone.history.start()

    # autosave
    #sisyphus = $('.js_slide_form').sisyphus(
    #  locationBased: true
    #  timeout: 10
    #)
    #$('.js_cancel_btn').on('click', ->
    #  sisyphus.manuallyReleaseData()
    #)

  if $('body.slides.play').length ||
     $('body.slides.blank').length ||
     $('body.slides.preview').length

    $.deck('.slide')

    if $('.js_btns').length
      setTimeout(->
        $('.js_btns').removeClass('active')
      , 3000)

    $('.js_theme').on('click', (e) ->
      e.preventDefault()
      theme = $(this).data('theme')
      href = $('.js_theme_link').attr('href').replace(/\/[^\/]*\.css/, "/#{theme}.css")
      $('.js_theme_link').attr('href', href) 
    )

    $('.js_transition').on('click', (e) ->
      e.preventDefault()
      transition = $(this).data('transition')
      href = $('.js_transition_link').attr('href').replace(/\/[^\/]*\.css/, "/#{transition}.css")
      $('.js_transition_link').attr('href', href) 
    )



)

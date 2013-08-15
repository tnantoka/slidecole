# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(->

  if $('body.users.show').length || 
     $('body.categories.show').length || 
     $('body.categories.uncategorized').length ||
     $('body.slides.index').length ||
     $('body.categories.index').length ||
     $('body.categories.create').length ||
     $('body.categories.edit').length ||
     $('body.categories.update').length 
    $('.js_filter').on('keyup', (e) ->
      $this = $(this)
      q = $.trim($this.val().toLowerCase())
      $list = $this.parents('div').next('div, ul')
      $list.children('a, li').each(->
        $item = $(this)
        if !q || $item.text().toLowerCase().indexOf(q) > 0
          $item.show()
        else
          $item.hide()
      )
    ).keyup()

)

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Dropzone.autoDiscover = false

$(->

  if $('body.slides.new').length ||
     $('body.slides.create').length ||
     $('body.slides.edit').length ||
     $('body.slides.update').length ||
     $('body.attachments.index').length 

    # dropzone
    dropzone = new Dropzone('#new_attachment', 
      paramName: 'attachment[file]'
      dictDefaultMessage: 'Drop files here to upload (<= 512 KB)' 
    )
    #dropzone.on('addedfile', ->
    #)

)

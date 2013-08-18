window.PageFormView = Backbone.View.extend(
  events: 
    'keypress input' : 'onKeypressInput'
    'click .js_insert_btn' : 'onClickInsert'
    'click .js_insert' : 'onClickInsert'
    'click .js_close' : 'onClickClose'
    'click .js_kind' : 'onClickKind'
    'click .js_delete' : 'onClickDelete'
    'click .js_up' : 'onClickUp'
    'click .js_down' : 'onClickDown'
    'click .js_first' : 'onClickFirst'
    'click .js_last' : 'onClickLast'
    'click .js_duplicate' : 'onClickDuplicate'
    'click .js_toggle' : 'onClickToggle'

    'click .js_list_add' : 'onClickListAdd'
    'click .js_list_delete' : 'onClickListDelete'

    'click .js_table_refresh' : 'onClickTableRefresh'

    'click .js_image_refresh' : 'onClickImageRefresh'
    'click .js_image_prev' : 'onClickImagePrev'
    'click .js_image_next' : 'onClickImageNext'
    'click .js_image' : 'onClickImage'
  initialize: ->
    _.bindAll(this, 'onKeyupField', 'render')
    this.listenTo(this.model, 'change:order', this.render)
    #this.listenTo(this.model, 'destroy', this.remove);

  render: ->
    this.$el.html(JST['templates/page_form'](model: this.model))

    this.$el.on('keyup', 'input, textarea', _.throttle(this.onKeyupField, 3000))

    if this.model.get('kind') == 'image'
      this.imageIndex = 0
      this.loadImages() 

    this.preview()

    return this
  preview: ->
    params = this.$('.js_edit *').serialize()
    self = this
    $.post('/pages/preview', params, (data) ->
      win = self.$('.js_preview_frame').get(0).contentWindow
      if win && win.$
        win.$('.deck-container .slide').remove()
        win.$('.deck-container').prepend(data)
        win.$.deck('.slide')
      else
        self.$('.js_preview_frame').on('load', ->
          self.preview()
        )        
    )

  onKeyupField: (e) ->
    this.model.set('title', this.$('.js_title').val())
    content = {
      items: [] 
      records: []
    }
    this.$('[data-content]').each(->
      $this = $(this)
      if $this.data('content') == 'items'
        content.items[$this.data('index')] = $this.val()
      else if $this.data('content') == 'records'
        i = $this.data('row-index') 
        j = $this.data('cell-index') 
        content.records[i] = { items: [] } if !content.records[i]
        content.records[i].items[j] = $this.val()
      else
        content[$this.data('content')] = $this.val()
    )
    this.model.set('content', content) 

    this.preview()

  onKeypressInput: (e) ->
    e.preventDefault() if e.which == 13

  # insert
  onClickInsert: (e) ->
    e.preventDefault()
    this.$('.js_insert').addClass('active')
    this.$('.js_navbar').show(
      effect: 'blind'
      duration: 'fast'
    )
  onClickClose: (e) ->
    e.preventDefault()
    e.stopPropagation()
    self = this
    this.$('.js_navbar').hide(
      effect: 'blind'
      duration: 'fast'
      complete: ->
        self.$('.js_insert').removeClass('active')
    )
  onClickKind: (e) ->
    e.preventDefault()
    e.stopPropagation()
    order = this.model.get('order') + 1
    this.model.collection.add(
      kind: $(e.currentTarget).data('kind') 
      order: order 
      content: 
        items: ['']
        rows: 2
        cols: 2
        records: [{ items: ['', ''] }, { items: ['', ''] }]
    , at: order)
    this.onClickClose(e)

  # toolbar
  onClickDelete: (e) ->
    e.preventDefault()
    if this.model.collection.length > 1
      #this.model.destroy()
      this.model.collection.remove(this.model)
      this.remove()
  onClickUp: (e) ->
    e.preventDefault()
    this.move(this.model.get('order') - 1) if this.model.get('order') > 0
  onClickFirst: (e) ->
    e.preventDefault()
    this.move(0) if this.model.get('order') > 0
  onClickDown: (e) ->
    e.preventDefault()
    this.move(this.model.get('order') + 1) if this.model.get('order') < this.model.collection.length - 1
  onClickLast: (e) ->
    e.preventDefault()
    this.move(this.model.collection.length - 1) if this.model.get('order') < this.model.collection.length - 1
  onClickDuplicate: (e) ->
    e.preventDefault()
    order = this.model.get('order') + 1
    this.model.collection.add(
      kind: this.model.get('kind') 
      order: order 
      title: this.model.get('title')
      content: this.model.get('content')
    , at: order)

  onClickToggle: (e) ->
    e.preventDefault()
    $body = this.$('.js_body').toggle(
      effect: 'blind'
      duration: 'fast'
      complete: ->
        if $body.is(':visible')
          $(e.currentTarget).html('<i class="icon-caret-up"></i>')
        else
          $(e.currentTarget).html('<i class="icon-caret-down"></i>')
    )

  # list
  onClickListAdd: (e) ->
    e.preventDefault()
    content = this.model.get('content')
    content.items.push('')
    this.model.set('content', content)
    this.render()
  onClickListDelete: (e) ->
    e.preventDefault()
    content = this.model.get('content')
    content.items.splice($(e.currentTarget).data('index'), 1)
    this.model.set('content', content)
    this.render()

  # table
  onClickTableRefresh: (e) ->
    e.preventDefault()
    rows = parseInt(this.$('.js_rows').val())
    cols = parseInt(this.$('.js_cols').val())

    content = this.model.get('content')
    records = content.records
    records.splice(rows)
    if records.length < rows
      records.push(items: []) for i in [0..(rows - records.length - 1)]
        
    _.each(records, (row) ->
      if row.length < cols
        row.items.push('') for i in [0..(cols - row.items.length - 1)]
      else
        row.items.splice(cols)
    )

    this.model.set('content', content)
    this.model.set('rows', rows)
    this.model.set('cols', cols)
    this.render()

  # image
  onClickImageRefresh: (e) ->
    e.preventDefault()
    this.imageIndex = 0
    this.loadImages(this.imageIndex)
  onClickImagePrev: (e) ->
    e.preventDefault()
    this.imageIndex--
    this.imageIndex = 0 if this.imageIndex < 0
    this.loadImages(this.imageIndex)
  onClickImageNext: (e) ->
    e.preventDefault()
    this.imageIndex++
    this.loadImages(this.imageIndex)
  onClickImage: (e) ->
    e.preventDefault()
    this.$('.js_image_url').val($(e.currentTarget).data('path'))

  loadImages: (p) ->
    $list = this.$('.image_list').html('')
    $.get("/attachments.json?p=#{p}", (data) ->
      for d in data
        $list.append("""
          <li><a href="#" class="js_image" data-path="#{d.path}"><img src="#{d.path}" class="img-thumbnail"></a>
        """)
    )

  # helper
  move: (order) ->
    this.model.set('order', order)
    this.remove()
    collection = this.model.collection
    collection.remove(this.model, silent: true)
    collection.add(this.model, at: order)

)

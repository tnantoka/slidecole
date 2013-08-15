window.SlideFormView = Backbone.View.extend(
  events: 
    'click .js_options_btn': 'onClickOptions'
    'click .js_preview_btn': 'onClickPreview'
    'submit .js_slide_form' : 'onSubmit'
  initialize: ->
    this.listenTo(this.collection, 'add', this.onAdd)
    this.deleteIds = []
  render: ->
    this.pageListFormView = new PageListFormView(
      collection: this.collection
    );
    this.$('.js_page_list').html(this.pageListFormView.render().el)
    this.listenTo(this.collection, 'remove', this.onRemove)

    pageNavView = new PageNavView(
      collection: this.collection
    )
    this.$('.js_page_nav').append(pageNavView.render().el)

    return this
  onClickOptions: (e) ->
    e.preventDefault()
    this.$('.js_options').toggle(
      effect: 'blind'
      duration: 'fast'
    )
  onClickPreview: (e) ->
    e.preventDefault()
    $form = this.$('.js_slide_form').clone()
    $form.attr('action', '/slides/preview')
    $form.attr('method', 'post')
    $form.attr('target', '_blank')
    $form.css('display', 'none')
    $form.find('[name="_method"]').remove()
    $form.find('[name*="[id]"]').remove()
    $form.find('iframe').remove()
    $(document.body).append($form)
    $form.submit()
  onRemove: (model) ->
    if !model.isNew()
      this.deleteIds.push(model.get('id'))
  onSubmit: (e) ->
    #e.preventDefault() 
    self = this
    _.each(this.deleteIds, (id, i) ->
      self.$('.js_destroy_list').append(JST['templates/_destroy'](
        id: id
        i: self.collection.length + i
      ))
    )
)

window.PageListFormView = Backbone.View.extend(
  initialize: ->
    this.listenTo(this.collection, 'add', this.onAdd)
  render: ->
    this.collection.each((model) ->
      this.onAdd(model)
    , this)
    return this
  onAdd: (model) ->
    pageFormView = (new PageFormView(model: model)).render()

    index = this.collection.indexOf(model)
    if index == 0
      this.$el.prepend(pageFormView.el)
    else
      pageFormView.$el.insertAfter(this.$el.children()[index-1])

    if model.isNew()
      this.$(pageFormView.el).find('input:text, textarea').eq(0).focus()
)

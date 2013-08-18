instance = null

window.PageList = Backbone.Collection.extend(
  model: Page
  #comparator: (page) -> 
  #  page.get('order')
  constructor: ->
    if !instance
      instance = this
      Backbone.Collection.apply(instance, arguments)
    return instance
  add: (models, options) ->
    Backbone.Collection.prototype.add.apply(this, arguments)
    this.each((model, i) ->
      model.set('order', i)
    )
    this.trigger('added')
  remove: (models, options) ->
    Backbone.Collection.prototype.remove.apply(this, arguments)
    this.each((model, i) ->
      model.set('order', i)
    )
    this.trigger('removed')
)


window.PageNavView = Backbone.View.extend(
  initialize: ->
    _.bindAll(this, 'render')
    #this.listenTo(this.collection, 'add', this.render)
    #this.listenTo(this.collection, 'remove', this.render)
    this.listenTo(this.collection, 'added', this.render)
    this.listenTo(this.collection, 'remove', this.render)
  render: ->
    this.$el.html(JST['templates/page_nav'](collection: this.collection))

    $(document.body).scrollspy('refresh')

    return this
)


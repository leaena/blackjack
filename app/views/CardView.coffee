class window.CardView extends Backbone.View

  className: 'card'

  template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    rankName = @model.attributes.rankName
    suitName = @model.attributes.suitName
    if @model.get 'revealed'
      @$el.css 'background', 'url(img/cards/' + rankName + '-' + suitName + '.png) no-repeat center'
    else
      @$el.addClass 'covered'

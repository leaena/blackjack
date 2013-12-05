class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'add remove change', => @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    score = if @collection.scores()[1] and @collection.scores()[1] <= 21
      @collection.scores()[1]
    else
      @collection.scores()[0]
    if score > 21
      @collection.trigger 'bust', @
    @$('.score').text score

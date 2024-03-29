class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  checkScore: ->
    if @scores()[1] == 21
      @trigger 'stand', @

  hit: -> 
    @add(@deck.pop()).last()
    if @scores()[0] > 21
      @trigger 'bust'
  stand: -> @trigger 'stand'

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only scor.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or (if card.get 'revealed' then card.get 'value' else 0) is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

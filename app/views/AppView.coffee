class window.AppView extends Backbone.View
  el: '<div>'
  template: _.template '
    <div class="scores"></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .reset": -> 
      @model.startGame()
      @render()

  initialize: -> 
    @model.on 'all', @viewLogic, @
    @model.startGame()
    @render()

  

  viewLogic: (event)->
    switch event
      when 'playerBust' then @gameEnd 'You bust! - Dealer wins!'
      when 'dealerBust' then @gameEnd 'Dealer busts! - You win!'
      when 'playerWin' then @gameEnd 'You win!'
      when 'dealerWin' then @gameEnd 'Dealer wins!'
      when 'blackjack' then @gameEnd 'Blackjack! You win!'
      when 'push' then @gameEnd 'Tie!'

  gameEnd: (message)->
    html = '<h1>' + message + '</h1>'
    $('button').hide()
    @$el.append html + '<button class="reset">New Game?</button>'


  render: ->
    $('h1').remove()
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

    # @$('.scores').html '<span> Player Wins: ' + (window.localStorage['playerWin'] || 0) + ' </span> &nbsp; <span> Dealer Wins: ' + (window.localStorage['dealerWin'] || 0) + '</span>'

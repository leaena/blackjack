class window.AppView extends Backbone.View
  el: '<div>'
  template: _.template '
    <div class="scores"></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <br />
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .reset": -> @model.newGame()

  initialize: -> 
    @render()
    @model.on('reset', =>
      @render()
    )
    @model.on("playerBust", => 
      @gameEnd 'You bust! - Dealer wins!'
    )
    @model.on("dealerBust", =>
      @gameEnd 'Dealer busts! - You win!'
    )
    @model.on('playerWin', =>
      @gameEnd 'You win!'
    )
    @model.on('dealerWin', =>
      @gameEnd 'Dealer wins!'
    )

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

    @$('.scores').html '<span> Player Wins: ' + (window.localStorage['playerWin'] || 0) + ' </span> &nbsp; <span> Dealer Wins: ' + (window.localStorage['dealerWin'] || 0) + '</span>'

class window.AppView extends Backbone.View
  el: '<div>'
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()

  initialize: -> 
    @render()
    @model.get('playerHand').on("stand", => 
      # @undelegateEvents()
    )
    @model.get('playerHand').on("bust", => 
      # @undelegateEvents()
      @gameEnd 'You bust! - Dealer wins!'
    )
    @model.get('dealerHand').on("bust", =>
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
    $('button').toggle()
    $('body').prepend html

    # setTimeout =>
    #   @model.set 'playerHand', @model.get('deck').dealPlayer()
    #   @model.set 'dealerHand', @model.get('deck').dealDealer()
    #   @render()
    # , 500


  render: ->
    $('h1').remove()
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

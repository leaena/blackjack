#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on("stand", => 
      @dealerHit()
      @gameEnd()
    )

    @get('dealerHand').on('bust', ->
      @trigger('dealerBust')
    )

  dealerHit: ->
    @get('dealerHand').at(0).flip()
    while @get('dealerHand').scores()[1] < 17 or @get('dealerHand').scores()[0] < 17
      @get('dealerHand').hit()

  gameEnd: ->
    playerScore = if @get('playerHand').scores()[1] and @get('playerHand').scores()[1] < 21
      @get('playerHand').scores()[1]
    else
      @get('playerHand').scores()[0]
    dealerScore = if @get('dealerHand').scores()[1] and @get('dealerHand').scores()[1] < 21
      @get('dealerHand').scores()[1]
    else
      @get('dealerHand').scores()[0]
    if(dealerScore <= 21)
      if(playerScore <= dealerScore)
        @trigger('dealerWin')
      else
        @trigger('playerWin')

  newGame: ->   
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on("stand", => 
      @dealerHit()
      @gameEnd()
    )
    @get('dealerHand').on('bust', ->
      @trigger('dealerBust')
    )
    @trigger('newGame')

    

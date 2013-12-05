#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on("stand", => 
      @dealerGame()
    )
    @get('playerHand').on('bust', =>
      @trigger 'playerBust'
    )
    @get('dealerHand').on('bust', =>
      @trigger 'dealerBust'
    )

  dealerGame: ->
    @get('dealerHand').at(0).flip()
    playerScore = @aceShuffle()[0]
    dealerScore = @aceShuffle()[1]
    interval = null
    if dealerScore < playerScore and dealerScore < 17
      interval = setInterval =>
        if dealerScore >= 17 or dealerScore >= playerScore
          @gameEnd()
          clearInterval(interval);
        else
          @get('dealerHand').hit()
          playerScore = @aceShuffle()[0]
          dealerScore = @aceShuffle()[1]
      , 1000
    else
      @gameEnd()

  gameEnd: ->
    playerScore = @aceShuffle()[0]
    dealerScore = @aceShuffle()[1]

    if(dealerScore <= 21)
      if(playerScore <= dealerScore)
        @trigger('dealerWin')
      else
        @trigger('playerWin')

  newGame: ->
    @initialize()
    @trigger 'reset'

  aceShuffle: ->
    playerScore = if @get('playerHand').scores()[1] and @get('playerHand').scores()[1] <= 21
      @get('playerHand').scores()[1]
    else
      @get('playerHand').scores()[0]
    dealerScore = if @get('dealerHand').scores()[1] and @get('dealerHand').scores()[1] <= 21
      @get('dealerHand').scores()[1]
    else
      @get('dealerHand').scores()[0]
    [playerScore, dealerScore]

    

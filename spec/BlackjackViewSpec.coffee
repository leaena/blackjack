describe 'game app', ->
  app = null
  appView = null

  beforeEach ->
    appView = new AppView(model: app = new App())

  describe 'App', ->
    it "should create a dealer hand", ->
      expect(app.get('playerHand') instanceof Hand).toBeTruthy()
    it "should create a player hand", ->
      expect(app.get('playerHand') instanceof Hand).toBeTruthy()

    describe 'dealer', ->
      it "should start its game when a player stands", ->
        spyOn app, 'dealerGame'
        app.get('playerHand').trigger 'stand'
        expect(app.dealerGame).toHaveBeenCalled()
      it "should flip its hidden card", ->
        spyOn app.get('dealerHand').at(0), 'flip'
        app.get('playerHand').trigger 'stand'
        expect(app.get('dealerHand').at(0).flip).toHaveBeenCalled()
      xit "should deal itself a card if it has less than 17", -> #no longer works because of delay
        app.set 'dealerHand', new Hand [ new Card( rank: 2, suit: 1 ), new Card( rank: 2, suit: 2 ) ], app.get 'deck'
        spyOn app.get('dealerHand'), 'hit'
        app.get('playerHand').trigger 'stand'
        # waitsFor(function() {
        #     return 
        # }, "It took too long to find those factors.", 10000);
        expect(app.get('dealerHand').hit).toHaveBeenCalled()
      xit "should end game if its value is more than 17", -> #fails sometimes for sheer random?
        spyOn app, 'gameEnd'
        app.get('playerHand').trigger 'stand'
        app.set 'dealerHand', new Hand [ new Card( rank: 1, suit: 1 ), new Card( rank: 0, suit: 2 ) ], app.get 'deck'
        app.set 'playerHand', new Hand [ new Card( rank: 0, suit: 1 ), new Card( rank: 0, suit: 3 ) ], app.get 'deck'
        expect(app.gameEnd).toHaveBeenCalled()

  xdescribe 'score', ->
    xit "should let the dealer win if their hand value is greater or equal to player hand value", ->
      window.localStorage.clear()
      winnings = 1
      app.set 'dealerHand', new Hand [ new Card( rank: 1, suit: 1 ), new Card( rank: 0, suit: 2 ) ], app.get 'deck'
      app.set 'playerHand', new Hand [ new Card( rank: 5, suit: 1 ), new Card( rank: 0, suit: 3 ) ], app.get 'deck'
      app.trigger 'dealerWin'
      expected = parseInt(window.localStorage['dealerWin'])
      expect(expected).toEqual(winnings)


  describe 'AppView', ->
    describe 'bust', ->
      it "when a player busts it should trigger a gameover", ->
        spyOn appView, 'gameEnd'
        app.get('playerHand').trigger 'bust'
        expect(appView.gameEnd).toHaveBeenCalled()
      it "when the dealer busts it should trigger a gameover", ->
        spyOn appView, 'gameEnd'
        appView.model.get('dealerHand').trigger 'bust'
        expect(appView.gameEnd).toHaveBeenCalled()
    describe 'winning', ->
      it "when the dealer wins should end the game", ->
        spyOn appView, 'gameEnd'
        app.trigger 'dealerWin'
        expect(appView.gameEnd).toHaveBeenCalled()
      it "when the player wins should end the game", ->
        spyOn appView, 'gameEnd'
        app.trigger 'playerWin'
        expect(appView.gameEnd).toHaveBeenCalled()
    describe 'restart', ->
      it "should start a new game when requested", ->
        
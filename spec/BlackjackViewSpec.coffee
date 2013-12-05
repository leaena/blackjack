describe 'App', ->
  app = null
  appView = null

  beforeEach ->
    appView = new AppView(model: app = new App())

  describe 'stand', ->
    it "when a player busts it should trigger a gameover", ->
      spyOn(appView, 'gameEnd')
      appView.model.get('playerHand').trigger('bust')
      expect(appView.gameEnd).toHaveBeenCalled()
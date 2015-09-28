ReturnValue = require '../src/return-value'

describe 'ReturnValue', ->
  it 'should exist', ->
    @sut = new ReturnValue

  describe '-> onEnvelope', ->
    it 'should raise an exception', ->
      func = => @sut.onEnvelope()
      expect(func).to.throw 'onEnvelope is not implemented'

  describe 'a fake subclass of ReturnValue that implements onEnvelope', ->
    beforeEach ->
      @onEnvelopeSpy = onEnvelopeSpy = sinon.stub().returns fo: 'sho'

      class TallBuilding extends ReturnValue
        onEnvelope: onEnvelopeSpy

      @tallBuilding = new TallBuilding

    describe 'when the class is written to', ->
      beforeEach (done) ->
        @tallBuilding.on 'end', done

        @things = []
        @tallBuilding.on 'readable', =>
          while thing = @tallBuilding.read()
            @things.push thing


        @tallBuilding.write
          message: 'very tall house'
          config: {}
          data: {}

      it 'should call onEnvelope with the envelope', ->
        expect(@onEnvelopeSpy).to.have.been.calledWith
          message: 'very tall house'
          config: {}
          data: {}

      it 'should make onEnvelope return value readable', ->
        expect(@things).to.deep.contain fo: 'sho'

    describe 'when the class is written to with a callback', ->
      beforeEach (done) ->
        @tallBuilding.write {}, done

      it 'should get here', ->

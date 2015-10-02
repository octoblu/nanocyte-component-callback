CallbackComponent = require '../src/callback'

describe 'CallbackComponent', ->
  it 'should exist', ->
    @sut = new CallbackComponent

  describe '-> onEnvelope', ->
    it 'should raise an exception', ->
      func = => @sut.onEnvelope()
      expect(func).to.throw 'onEnvelope is not implemented'

  describe 'a fake subclass of CallbackComponent that implements onEnvelope', ->
    beforeEach ->
      @onEnvelopeSpy = onEnvelopeSpy = sinon.stub().yields null, fo: 'sho'

      class CatGravity extends CallbackComponent
        onEnvelope: onEnvelopeSpy

      @catGravity = new CatGravity

    describe 'when the class is written to', ->
      beforeEach (done) ->
        @catGravity.on 'end', done

        @things = []
        @catGravity.on 'readable', =>
          while thing = @catGravity.read()
            @things.push thing

        @catGravity.write
          message: 'very tall house'
          config: {}
          data: {}

      it 'should call onEnvelope with the envelope', ->
        expect(@onEnvelopeSpy).to.have.been.calledWith
          message: 'very tall house'
          config: {}
          data: {}

      it 'should make onEnvelope callback value readable', ->
        expect(@things).to.deep.contain fo: 'sho'

    describe 'when the class is written to with a callback', ->
      beforeEach (done) ->
        @catGravity.write {}, done

      it 'should get here', ->

  describe 'a fake subclass of CallbackComponent that yields an error', ->
    beforeEach ->
      @onEnvelopeSpy = onEnvelopeSpy = sinon.stub().yields new Error 'Bludgeoned with trophy'

      class GleamingAward extends CallbackComponent
        onEnvelope: onEnvelopeSpy

      @gleamingAward = new GleamingAward

    describe 'when the class is written to', ->
      beforeEach (done) ->
        @gleamingAward.on 'end', done
        @gleamingAward.on 'error', (@error) =>

        @things = []
        @gleamingAward.on 'readable', =>
          while thing = @gleamingAward.read()
            @things.push thing

        @gleamingAward.write
          message: 'very tall house'
          config: {}
          data: {}

      it 'should call onEnvelope with the envelope', ->
        expect(@onEnvelopeSpy).to.have.been.calledWith
          message: 'very tall house'
          config: {}
          data: {}

      it 'should emit the callback error on error', ->
        expect(=> throw @error).to.throw 'Bludgeoned with trophy'

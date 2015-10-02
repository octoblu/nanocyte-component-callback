{Transform} = require 'stream'

class CallbackComponent extends Transform
  constructor: ->
    super objectMode: true

  onEnvelope: (envelope, callback) =>
    throw new Error('onEnvelope is not implemented')

  _transform: (envelope, enc, next) =>
    @onEnvelope envelope, (error, message) =>
      if error?
        next error
        @push null
        return
      @push message
      @push null
      next()

module.exports = CallbackComponent

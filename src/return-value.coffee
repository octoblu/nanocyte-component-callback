{Transform} = require 'stream'

class ReturnValue extends Transform
  constructor: ->
    super objectMode: true

  onEnvelope: (envelope) =>
    throw new Error('onEnvelope is not implemented')

  _transform: (envelope, enc, next) =>
    @push @onEnvelope envelope
    @push null
    next()

module.exports = ReturnValue

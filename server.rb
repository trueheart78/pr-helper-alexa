require 'sinatra'
require 'json'
require 'alexa_rubykit'

RESPONSES = [
  'Has it been peer reviewed?',
  'Have you completed the development checklist?',
  'Has it received a manager review?',
  'Has RMT reviewed it?',
  'You are good to deploy'
]

get '/' do
  'Alexa, tell coach I need help'
end

post '/' do
  req = AlexaRubykit::Request.new JSON.parse(request.body.read)

  response = AlexaRubykit::Response.new
  if req.json['request']['type'] == 'IntentRequest' && req.json['request']['intent']['name'] == 'AMAZON.NoIntent'
    response.add_speech 'Then you should do that next'
    end_session = true
  else
    response_number = req.session.attributes.fetch('responseNumber', 0).to_i
    response.add_speech RESPONSES[response_number]
    response.add_session_attribute :responseNumber, response_number + 1
    end_session = (response_number >= RESPONSES.size - 1)
  end
  return response.build_response end_session
end

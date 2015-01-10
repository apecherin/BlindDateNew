# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run BlindDateNew::Application
# require 'faye'
#
# require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
#
# class ServerAuth
#   def incoming(message, callback)
#     if message['channel'] !~ %r{^/meta/}
#       if message['ext']['auth_token'] != FAYE_TOKEN
#         message['error'] = 'Invalid authentication token'
#       end
#     end
#     callback.call(message)
#   end
# end
#
# faye_server = Faye::RackAdapter.new(
#     :mount => '/faye',
#     :timeout => 25,
#     :engine => {
#         :type => 'redis',
#         :host => 'icefish.redistogo.com',
#         :port => '9045',
#         :password => '001dabe1f9c7735f948052898e8fb34e',
#         :database => 1
#     })
# faye_server.add_extension(ServerAuth.new)
# run faye_server
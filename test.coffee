RtmClient = require('@slack/client').RtmClient
RTM_EVENTS = require('@slack/client').RTM_EVENTS
RTM_CLIENT_EVENTS = require('@slack/client').CLIENT_EVENTS.RTM

config = require 'config'
configs = [
	'token',
	'monitoredChannel',
	'monitoredUser',
	'monitoredUsername'
	'observerChannel',
	'observer1',
	'observer1name',
	'observer2'
]

for key in Object.keys(config)
	if configs.indexOf(key) == -1 || config[key] == ""
		console.log "Error: #{key} has no value..."
		return

token = config.token
reg = "^\<\< ([\s\S]*)$"
regexp = new RegExp(reg)

#rtm = new RtmClient token, {logLevel:'debug'}
rtm = new RtmClient token
rtm.start()

rtm.on RTM_EVENTS.MESSAGE, (m)->
	# monitoredUser -> observerChannel
    if m.channel == config.monitoredChannel && m.user == config.monitoredUser
        rtm.sendMessage "#{config.monitoredUsername} to #{config.observer1name}\n\n>>>#{m.text}", config.observerChannel, messageSent = ->
            #option

	# (observerChannel -> ) client -> monitoredUser
    if m.channel == config.observerChannel && m.text.match(regexp)
        if m.user == config.observer1 || m.user == config.observer2
            rtm.sendMessage m.text.match(regexp)[1], config.monitoredChannel, messageSent = ->
                #option

process.on 'exit', (code)->
	if code != 0
		rtm.sendMessage "Error has occured...", config.observerChannel, messageSent = ->
			#option

# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.respond /countdown to (.*) on/i, (res) ->
    countdown = res.match[1]
    res.reply "I'm afraid I can't let you do that."
    res.reply "#{res.message.text}"
    res.reply "#{countdown}"

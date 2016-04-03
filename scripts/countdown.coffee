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

  robot.respond /time?/, (res) ->
    res.reply "My Time is #{new Date()}"

  robot.respond /countdown to (.*) on (.*)/, (res) ->
    countdown = res.match[1]
    date_text = res.match[2]
    date = Date.parse(date_text)
    store = robot.brain.get(countdown)
    if store
      res.reply "#{countdown} already set for #{store}"
      res.reply "update with `countdown update #{countdown} to #{date_text}`"
      return

    if !date
      res.reply "what day is #{date_text}? I do not understand it try MM/DD/YYYY"
      return

    if date <= Date.now()
      res.reply "I can't count backwards try a day in the future!"
      return

    res.reply "I can do that!"
    robot.brain.set countdown, date
    day_diff = Math.round((date - Date.now())/(1000*60*60*24))
    if day_diff > 0
      res.reply "#{countdown} is in #{day_diff} days"
    else if day_diff < 0
      res.reply "#{countdown} was #{Math.abs(day_diff)} days ago"
    else
      res.reply "#{countdown} is today!"

  robot.respond /countdown update (.*) to (.*)/, (res) ->
    countdown = res.match[1]
    date = res.match[2]
    res.reply "#{countdown}"
    res.reply "#{date}"

  robot.respond /countdowns\?/, (res) ->
    res.reply "No countdowns"

  robot.respond /days untill (.*)/, (res) ->
    countdown = res.match[1]
    res.reply "I don't have a #{countdown}"

module.exports = (robot) ->

  robot.respond /time?/, (res) ->
    res.reply "My Time is #{new Date()}"

  robot.respond /countdown help/, (res) ->
    res.send "Here are my commands:"
    res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
    res.send "*update a countdown*  : `countdown update <countdown name> to <MM/DD/YYY>`"
    res.send "*remove a countdown*  : `countdown destroy <countdown name>`"
    res.send "*list all countdowns* : `countdowns?`"
    res.send "*see a countdown*     : `days until <countdown name>`"

  robot.respond /countdown to (.*) on (.*)/, (res) ->
    countdown = res.match[1]
    date_text = res.match[2]
    today = new Date()
    today.setHours(0,0,0,0)
    date = new Date(date_text)
    store = robot.brain.get('countdowns')
    if !store
      store = {}

    if store[countdown]
      res.reply "#{countdown} already set for #{store[countdown]}"
      res.reply "update with `countdown update #{countdown} to #{date_text}`"
      return

    if date == 'Invalid Date'
      res.reply "what day is #{date_text}? I do not understand it try MM/DD/YYYY"
      return

    if date < today
      res.reply "I can't count backwards try a day in the future!"
      return

    res.reply "I can do that!"
    store[countdown] = date
    robot.brain.set 'countdowns', store
    day_diff = (date - today)/(1000*60*60*24)
    if day_diff > 1
      res.send "#{countdown} is in #{Math.round(day_diff)} days"
    else if day_diff < 0
      res.send "#{countdown} was #{Math.abs(Math.round(day_diff))} days ago"
    else
      res.send "#{countdown} is today!"

  robot.respond /countdown update (.*) to (.*)/, (res) ->
    countdown = res.match[1]
    date_text = res.match[2]
    today = new Date()
    today.setHours(0,0,0,0)
    date = new Date(date_text)
    store = robot.brain.get('countdowns')
    if !store || !store[countdown]
      res.send "#{countdown} does not exist"
      res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
      return

  robot.respond /countdown destroy (.*)/, (res) ->
    countdown = res.match[1]
    store = robot.brain.get('countdowns')
    if !store || !store[countdown]
      res.send "#{countdown} does not exist"
      res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
      return

    delete store[countdown]
    robot.brain.set 'countdowns', store
    res.send "*#{countdown}* has been removed"

  robot.respond /countdowns\?/, (res) ->
    store = robot.brain.get('countdowns')
    if store
      res.send "#{Object.keys(store)}"
    else
      res.send "I'm not counting anything down"

  robot.respond /days until (.*)/, (res) ->
    countdown = res.match[1]
    store = robot.brain.get('countdowns')
    if !store
      res.send "I don't have any countdowns"
      return
    if !store[countdown]
      res.send "I don't know about #{countdown}"
      return

    date = new Date(store[countdown])
    today = new Date()
    today.setHours(0,0,0,0)

    day_diff = (date - today)/(1000*60*60*24)
    if day_diff > 1
      res.send "#{countdown} is in #{Math.round(day_diff)} days"
    else if day_diff < -1
      res.send "#{countdown} was #{Math.abs(Math.round(day_diff))} days ago"
    else
      res.send "#{countdown} is today!"

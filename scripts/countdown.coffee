module.exports = (robot) ->

  robot.hear /^(\@lynchbot |!?)time\?/, (res) ->
    res.reply "My Time is #{new Date()}"

  robot.hear /^(\@lynchbot |!?)countdown help/, (res) ->
    res.send "Here are my commands:"
    res.send "*see a countdown*     : `days until <countdown name>`"
    res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
    res.send "*update a countdown*  : `countdown update <countdown name> to <MM/DD/YYY>`"
    res.send "*remove a countdown*  : `countdown destroy <countdown name>`"
    res.send "*list all countdowns* : `countdowns?`"

  robot.hear /^(\@lynchbot |!?)countdown to (.*) on (.*)/, (res) ->
    countdown = res.match[2]
    date_text = res.match[3]
    today = new Date()
    today.setHours(0,0,0,0)
    date = new Date(date_text)
    store = robot.brain.get('countdowns')
    if !store
      store = {}

    if store[countdown]
      res.send "#{countdown} already set for #{store[countdown]}"
      res.send "update with `countdown update #{countdown} to #{date_text}`"
      return

    if date == 'Invalid Date'
      res.send "what day is #{date_text}? I do not understand it try MM/DD/YYYY"
      return

    if date < today
      res.send "I can't count backwards try a day in the future!"
      return

    res.reply "I can create that!"
    store[countdown] = date
    robot.brain.set 'countdowns', store
    day_diff = (date - today)/(1000*60*60*24)
    if day_diff > 1
      res.send "#{countdown} is in #{Math.round(day_diff)} days"
    else if day_diff < 0
      res.send "#{countdown} was #{Math.abs(Math.round(day_diff))} days ago"
    else
      res.send "#{countdown} is today!"

  robot.hear /^(\@lynchbot |!?)countdown update (.*) to (.*)/, (res) ->
    countdown = res.match[2]
    date_text = res.match[3]
    today = new Date()
    today.setHours(0,0,0,0)
    date = new Date(date_text)
    store = robot.brain.get('countdowns')
    if !store || !store[countdown]
      res.send "#{countdown} does not exist"
      res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
      return
    res.reply "I can update that!"
    store[countdown] = date
    robot.brain.set 'countdowns', store
    day_diff = (date - today)/(1000*60*60*24)
    if day_diff > 1
      res.send "#{countdown} is in #{Math.round(day_diff)} days"
    else if day_diff < 0
      res.send "#{countdown} was #{Math.abs(Math.round(day_diff))} days ago"
    else
      res.send "#{countdown} is today!"


  robot.hear /^(\@lynchbot |!?)countdown rename (.*) to (.*)/, (res) ->
    countdown_old = res.match[2]
    countdown_new = res.match[3]
    store = robot.brain.get('countdowns')
    if !store || !store[countdown_old]
      res.send "#{countdown_old} does not exist"
      res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
      return
    res.send "I can rename that"
    store[countdown_new] = store[countdown_old]
    delete store[countdown_old]
    robot.brain.set 'countdowns', store
    res.send "#{countdown_old} has been renamed to #{countdown_new}"

  robot.hear /^(\@lynchbot |!?)countdown destroy (.*)/, (res) ->
    countdown = res.match[2]
    store = robot.brain.get('countdowns')
    if !store || !store[countdown]
      res.send "#{countdown} does not exist"
      res.send "*create a countdown*  : `countdown to <countdown name> on <MM/DD/YYYY>`"
      return
    res.send "I can destory that"
    delete store[countdown]
    robot.brain.set 'countdowns', store
    res.send "*#{countdown}* has been removed"

  robot.hear /^(\@lynchbot |!?)countdowns\?/, (res) ->
    store = robot.brain.get('countdowns')
    if store
      keys = Object.keys(store)
      res.send "I'm tracking #{keys.length}: #{keys.join(', ')}"
    else
      res.send "I'm not counting anything down"

  robot.hear /^(\@lynchbot |!?)days until (.*)/, (res) ->
    countdown = res.match[2]
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

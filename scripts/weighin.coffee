module.exports = (robot) ->

  robot.hear /^weigh-in help$/i, (res) ->
    res.send "each weigh in uses the current date and time"
    res.send "each user has their own log"
    res.send "only you can create, list and view your details"
    res.send "*create*      : `weigh-in <numbers>lbs`"
    res.send "*list all*    : `weigh me out`"
    res.send "*performance* : `weigh-in performance`"

  robot.hear /^weigh-in (\d+)lbs$/i, (res) ->
    user = res.message.user
    weight = res.match[1]
    store = robot.brain.get('weigh-ins')
    right_now = new Date()
    res.send "saving #{weight}lbs to #{user.id}"
    if !store
      store = {}
    if !store[user.id]
      store[user.id] = []
      res.send "logging your first weigh in!"

    store[user.id].push {'date': right_now, 'weight': weight}
    robot.brain.set 'weigh-ins', store
    count = store[user.id].length
    res.send "#{count} weigh-ins" if count > 1

  robot.hear /^weigh me out$/i, (res) ->
    user = res.message.user
    store = robot.brain.get('weigh-ins')
    if !store || !store[user.id]
      res.send "I don't have weigh-ins for #{user.name}"
      return

    res.send "#{user.name} has weighed in #{store[user.id].length} times"
    for weighIn in store[user.id]
      do (weighIn) ->
        res.send "#{weighIn["weight"]}lbs on #{weighIn["date"]}"

  robot.hear /^weigh-in performance$/i, (res) ->
    user = res.message.user
    store = robot.brain.get('weigh-ins')
    if !store || !store[user.id]
      res.send "I don't have weigh-ins for #{user.name}"
      return
    if (store[user.id].length <= 1)
      res.send "I only have one weigh-in for #{user.name}"
      res.send "#{store[user.id][0]["weight"]}lbs on #{store[user.id][0]["date"]}"
      return
    weights = store[user.id]
    first = weights[0]
    last  = weights[weights.length - 1]
    if last['weight'] < first['weight']
      change = 'lost'
    else
      change = 'gained'

    sum = 0
    idx = 0
    for weight in weights.slice(1)
      do (weight) ->
        oneDay = 24*60*60*1000
        this_date = new Date(weight['date'])
        last_date = new Date(weights[idx]['date'])
        date_diff = Math.round(Math.abs((this_date - last_date)/(oneDay)))
        weight_diff = weight['weight'] - weights[idx]['weight']
        sum = sum + weight_diff/date_diff
        idx = 1+idx

    performance = sum/weights.length

    diff = Math.abs(last['weight'] - first['weight'])
    res.send "*#{user.name} states*"
    res.send "*#{change}* : #{diff}lbs"
    res.send "*weigh-ins* : #{weights.length}"
    res.send "*performance* : #{performance} avg pounds per day"

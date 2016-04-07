module.exports = (robot) ->

  robot.hear /^weigh-in (\d+)lbs$/i, (res) ->
    user = res.message.user
    weight = res.match[1]
    store = robot.brain.get('weigh-ins')
    right_now = new Date()
    if !store
      store = {}
    if store[user.id]
      res.send "last logged #{store[user.id].last['weight']}"
    else
      store[user.id] = []
      res.send "logging your first weigh in!"

    store[user.id].push {'date': right_now, 'weight': weight}
    robot.brain.set 'weigh-ins', store
    res.send "saved"
    return

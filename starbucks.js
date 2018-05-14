const fs = require('fs')
const util = require('util')
const entities = require('html-entities')
fs.readFile('starbucks-stores.txt', function(err, data) {
  if (err) {
    console.log(err)
    return
  }

  const Entities = entities.AllHtmlEntities
  const entities2 = new Entities()

  let storesJson = data.toString().trim()
  storesJson = entities2.decode(storesJson)
  storesJson = new String(storesJson)
  storesJson = JSON.parse(storesJson)
  console.log(util.inspect(storesJson, true, 10,true))
});

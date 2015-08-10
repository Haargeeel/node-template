var express = require('express')
  , bodyParser = require('body-parser')

var app = express()

app.set('views', __dirname + '/build/views')
app.set('view engine', 'jade')

app.use(express.static(__dirname + '/build/public'))
app.use(bodyParser.json())

app.get('/', function(req, res) {
  res.render('index')
})

var server = app.listen(3000, function() {
  var host = server.address().address
  var port = server.address().port
  console.log('Server running at http://%s:%s', host, port)
})

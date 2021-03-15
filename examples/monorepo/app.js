// This is the server

var express = require('express');
var fs = require('fs');
var app = express();

var port = process.env['PORT'] || 3000;
var addr = process.env['BIND_ADDRESS'] || '127.0.0.1';

app.get('/', (req, res) => {
  res.send('Hello Polybox, from Node/Express on port ' + port + ' !');
});

// Listen to the port provided
app.listen(port, addr, () => {
  console.log('Node app listening on ' + addr + ':' + port);
});

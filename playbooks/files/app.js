var express = require('express');
var app = express();

app.get('/', function (req, res) {
    res.send('Hello World!');
});

app.listen(process.env.NODE_PORT_APP, function () {
    console.log('Example app listening on port ' + process.env.NODE_PORT_APP);
});

var links = [];
var casper = require('casper').create();

function getLinks() {
    //var links = document.querySelectorAll('a');
    var links = document.querySelectorAll('a[href^="/jp/asience/"]');
    return Array.prototype.map.call(links, function(e) {
        //return e.getAttribute('href');
        return e.text;
    });

//    var links = document.querySelectorAll('img[src^="/jp/kao_imgs/"]');
//    return Array.prototype.map.call(links, function(e) {
//        return e.getAttribute('alt');
//    });
}

casper.start('http://www.kao.com/jp/asience/index.html', function() {
    links = this.evaluate(getLinks);
    //this.echo("hoge");
});

casper.run(function() {
    this.echo(links.length + ' links found:');
    this.echo(' - ' + links.join('\n - ')).exit();
    //this.echo(links).exit();
});

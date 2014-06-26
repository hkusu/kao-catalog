keys = [
  "asience"
  "attack"
  "atrix"
]

getLinks2 = (key) ->
  links = document.querySelectorAll "a[href^=\"/jp/" + key + "/\"]"
  Array::map.call links, (e) ->
    #e.getAttribute "href"
    e.text

getLinks = ->
  #links = document.querySelectorAll "a"
  links = document.querySelectorAll "a[href^=\"/jp/asience/\"]"
  Array::map.call links, (e) ->
    e.getAttribute "href"
    #e.text

links = []
casper = require("casper").create()

#casper.start "http://www.kao.com/jp/asience/index.html", ->
#  links = @evaluate getLinks


casper.start().each keys, (self, key) ->
  url = "http://www.kao.com/jp/" + key + "/index.html"
  self.thenOpen url, ->
    @echo "=========="
    @echo @getTitle()
    @echo "=========="
    links = @evaluate getLinks
    #links = @evaluate(getLinks(key))
    @echo(" - " + links.join("\n - "))

casper.run ->
#  @echo links.length + " links found:"
#  @echo(" - " + links.join("\n - "))
  @exit()






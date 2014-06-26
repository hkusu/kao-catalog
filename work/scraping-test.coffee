getLinks = ->
  #links = document.querySelectorAll "a"
  links = document.querySelectorAll "a[href^=\"/jp/asience/\"]"
  Array::map.call links, (e) ->
    e.getAttribute "href"
    #e.text


links = []
casper = require("casper").create()


casper.start "http://www.kao.com/jp/asience/index.html", ->
  links = @evaluate getLinks


casper.run ->
  @echo links.length + " links found:"
  @echo(" - " + links.join("\n - "))
  @exit()




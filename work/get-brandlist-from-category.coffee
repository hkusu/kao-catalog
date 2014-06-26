categories = [
  "facialcleansing"
  "makecleansing"
  "facesheet"
  "lotion"
  "essence"
  "facesunscreen"
  "foundation"
  "pack"
  "lipcare"
  "shaving"
  "----------"
  "soap"
  "bodysoap"
  "handsoap"
  "handcare"
  "bodycream"
  "facebodysunscreen"
  "sunscreen"
  "bodysheet"
  "deodorant"
  "----------"
  "toothpaste"
  "toothseat"
  "toothliquid"
  "mouthwash"
  "toothbrush"
  "travelgoods"
  "----------"
  "bathpowder"
  "showercare"
  "----------"
  "shampoo"
  "treatment"
  "scalpconditioner"
  "scalpesthetique"
  "hairrestorer"
  "----------"
  "hairstyle"
  "hairspray"
  "brushingspray"
  "----------"
  "haircolor"
  "hairbleach"
  "hairmanicure"
  "hairdye"
  "whitecare"
  "----------"
  "clothcleanser"
  "softcleanser"
  "clothbleach"
  "starch"
  "clothfinisher"
  "clothfregrance"
  "clothdeodorant"
  "clotharomamist"
  "----------"
  "kitchencleanser"
  "kitchenbleach"
  "kitchencleaning"
  "cleanser"
  "----------"
  "housecleanser"
  "housewiper"
  "housecleaning"
  "bathcare"
  "toiletcare"
  "----------"
  "drink"
  "----------"
  "babydiaper"
  "hipsheet"
  "napkin"
  "menstruationpanties"
  "dischargesheet"
  "pantyliner"
  "malepad"
  "adultdiaper"
  "urinepad"
  "incontinencegoods"
  "caregoods"
  "hipscare"
  "----------"
  "onnetsu"
  "steamsheet"
  "eyemask"
  "----------"
  "pettoilet"
]

categoriesAAA = [
  "facialcleansing"
]

getLinks = ->
  links = document.querySelectorAll "section"
  Array::map.call links, (e) ->
    e.getAttribute "id"

links = []
casper = require("casper").create()

casper.start().each categories, (self, category) ->
#casper.start().each categoriesAAA, (self, category) ->
  url = "http://www.kao.com/jp/products/" + category + ".html"
  self.thenOpen url, ->
    @echo "=========="
    @echo category
    @echo "=========="
    links = @evaluate getLinks
    #links = @evaluate(getLinks(key))
    @echo(" - " + links.join("\n - "))

casper.run ->
#  @echo links.length + " links found:"
#  @echo(" - " + links.join("\n - "))
  @exit()






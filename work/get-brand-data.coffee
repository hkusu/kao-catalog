# ブランド名のリスト
#  "asience"
#  "attack"
#  "atrix"
#  "8x4"
#  "8x4men"
#  "essential"
#  "emal"
#  "emollica"
#  "guardhalo"
#  "keeping"
#  "kyukyutto"
#  "curel"
#  "safety"
#  "quickpunch"
#  "quickle"
#  "clearclean"
#  "cape"
#  "success"
#  "sanina"
#  "showertimebub"
#  "stylecare"
#  "smartguard"
#  "segreta"
#  "check"
#  "tsubushio"
#  "deepclean"
#  "nivea"
#  "niveaformen"
#  "nyantomo"
#  "newbeads"
#  "haiter"
#  "bub"
#  "bubshower"
#  "humming"
#  "biore"
#  "bioreurusara"
#  "bioresarasarauv"
#  "bioresarasara"
#  "biorebodydeli"
#  "bioreu"
#  "pyuora"
#  "purewhip"
#  "family"
#  "prettia"
#  "flairfragrance"
#  "blaune"
#  "blauneikumou"
#  "furomizuwonder"
#  "healthya"
#  "homing"
#  "white"
#  "mypet"
#  "magiclean"
#  "megurhythm"
#  "merries"
#  "merit"
#  "mensbiore"
#  "mensblaune"
#  "liese"
#  "resesh"
#  "relief"
#  "laurier"
#  "widehaiter"

links = []
casper = require("casper").create()

getPtag = ->
  links = document.querySelectorAll(".product-description p")
  Array::map.call links, (e) ->
    e.innerHTML

getLinup = ->
  links = document.querySelectorAll(".product-panel img")
  Array::map.call links, (e) ->
    e.getAttribute('src')

getLinupText = ->
  links = document.querySelectorAll(".product-panel a")
  Array::map.call links, (e) ->
    e.text

# 何かをスタートしないといけないみたいなので意味なくGoogleを指定
casper.start "http://google.fr/", ->

  # ブランド名をここに指定
  brand = "asience"

  url = "http://www.kao.com/jp/" + brand + "/index.html"
  @thenOpen url, ->
    @echo "["

    # 各商品のURLの一覧を取得
    links = @evaluate((brand_name) ->
      links = document.querySelectorAll("a[href^=\"/jp/" + brand_name + "/\"]")
      Array::map.call links, (e) ->
        e.getAttribute('href');
        #e.getAttribute('src');
        #e.text
    , brand)
    #@echo(" - " + links.join("\n - "))

    j = 0
    k = links.length
    # 各商品のURLに対してループ処理
    casper.start().each links, (self, link) ->

      url = "http://www.kao.com" + link
      self.thenOpen url, ->

        @echo "  {"

        # 画像URL(S)用の出力
        @echo "    \"img_s\": " + "\"#AAAAA#" + link + "#BBBBB#\","

        # 画像URL(L)用の出力
        @echo "    \"img_l\": " + "\"#BBBBB#" + link + "#CCCCC#\","

        # 商品名の出力
        @echo "    \"name\": " + "\"" + @getTitle() + "\","

        # 商品説明の出力
        links_sub = @evaluate getPtag
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/[\n\r]/g,"");
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/[<br>]/g,"");
          m++
        @echo("    \"text\": \"" + links_sub.join("\",\n    \"text\": \"") + "\",")

        # ラインナップ欄の出力
        links_sub = @evaluate getLinup
        links_sub2 = @evaluate getLinupText

        num = links_sub.length + 1
        if num is 1
          @echo("    \"lineup_num\": " + num)
        else
          @echo("    \"lineup_num\": " + num + ",")
          @echo "    \"lineup\": ["

          i = 0
          l = links_sub.length
          while i < links_sub.length
            @echo "      {"
            @echo "        \"img\": " + "\"" + links_sub[i] + "\","
            @echo "        \"name\": " + "\"" + links_sub2[i] + "\""
            if i < l - 1
              @echo "      },"
            else
              @echo "      }"
            i++
          @echo "    ]"

        if j < k - 1
          @echo "  },"
        else
          @echo "  }"
        j++

    casper.then ->
      @echo "]"

casper.run ->
  @exit()

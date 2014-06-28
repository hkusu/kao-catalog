
casper = require("casper").create()

getPtag = ->
  links = document.querySelectorAll(".product-description p")
  Array::map.call links, (e) ->
    e.innerHTML

getLinup = ->
  links = document.querySelectorAll(".product-panel img[src^=\"/jp/\"]")
  Array::map.call links, (e) ->
    e.getAttribute('src')

getLinupText = ->
  #links = document.querySelectorAll(".product-panel a")
  links = document.querySelectorAll(".product-panel img[src^=\"/jp/\"]")
  Array::map.call links, (e) ->
    #e.text
    e.getAttribute('alt')

# 何かをスタートしないといけないみたいなので意味なくGoogleを指定
casper.start "http://google.fr/", ->

  # ブランド名をスクリプト起動時の引数で受取り
  if casper.cli.args.length isnt 1
    @log 'Missing required argument.', 'error'
    @exit()
  brand = @cli.args[0]

  url = "http://www.kao.com/jp/" + brand + "/index.html"
  @thenOpen url, ->
    @echo "["

    urls = []

    # 各商品のURLの一覧を取得
    urls = @evaluate((brand_name) ->
      urls = document.querySelectorAll("a[href^=\"/jp/" + brand_name + "/\"]")
      Array::map.call urls, (e) ->
        e.getAttribute('href');
        #e.getAttribute('src');
        #e.text
    , brand)
    #@echo(" - " + urls.join("\n - "))

    links = []
    n = 0
    while n < urls.length
      if urls[n].match(/index.html/)
      else
        links.push(urls[n])
      n++

    j = 0
    k = links.length
    # 各商品のURLに対してループ処理
    casper.start().each links, (self, link) ->

      url = "http://www.kao.com" + link
      self.thenOpen url, ->

        @echo "  {"

        # 画像URL(S)用の出力
        link = link.replace(/\.html/g,"");
        link = link.replace(/\/jp/g,"");
        @echo "    \"img_s\": " + "\"/jp/kao_imgs" + link + "_img_s.jpg\","

        # 画像URL(L)用の出力
        @echo "    \"img_l\": " + "\"/jp/kao_imgs" + link + "_img_l.jpg\","

        # 商品名の出力
        title = @getTitle()
        title = title.replace(/^花王株式会社 /g,"")
        title = title.replace(/\ ［.+?］$/g,"")
        @echo "    \"name\": " + "\"" + title + "\","

        # 商品説明の出力
        links_sub = @evaluate getPtag
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/[\n\r]/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<br>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/\"/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<span.+?>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<\/span>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<font.+?>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<\/font>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<a.+?>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<\/a>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<u>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<\/u>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/<img.+?>/g,"")
          m++
        m = 0
        while m < links_sub.length
          links_sub[m] = links_sub[m].replace(/【.+?】$/g,"")
          m++
        o = 0
        while o < links_sub.length
          if links_sub[o].match(/^2014/)
          else
            @echo("    \"text\": \"" + links_sub[o] + "\",")
            o = links_sub.length
          o++

        # ラインナップ欄の出力
        links_sub = []
        links_sub2 = []
        links_sub_P = @evaluate getLinup
        links_sub2_P = @evaluate getLinupText
        p = 0
        while p < links_sub_P.length
          if links_sub_P[p].match(/^\/common/)
          else
            links_sub.push(links_sub_P[p])
            links_sub2.push(links_sub2_P[p])
          p++

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

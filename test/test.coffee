TestSuite = 
  compiledSrc: "../sdk.js"
  srcs: ["../src/helper.coffee", "../src/sc.coffee","../src/sc/api.coffee", "../src/sc/connect.coffee", "../src/sc/oembed.coffee", "../src/sc/record.coffee", "../src/sc/storage.coffee", "../src/sc/stream.coffee"]
  tests: ["helper-test.coffee", "sc-test.coffee", "sc/api-test.coffee"]
  initialize: () ->
    if TestSuite.inDevelopmentMode
      @loadJavascript "../vendor/recorder.js/recorder.js"
      @loadJavascript "../vendor/uri.js/build/uri.js", () ->
        window.SC ||= {}
        SC.URI = URI

      @loadCoffeescripts @srcs, () =>
        SC.initialize
          client_id: "YOUR_CLIENT_ID"
          baseUrl: "../vendor"
        SC._recorderSwfPath = "/recorder.js/recorder.swf"
        @loadCoffeescripts @tests
    else
      @loadJavascript @compiledSrc, () =>
        SC.initialize
          client_id: "YOUR_CLIENT_ID"
          baseUrl: ""
        @loadCoffeescripts(@tests)


  loadCoffeescripts: (scripts, callback) ->
    script = scripts.shift()
    if script == undefined
      callback() if callback
      return []
    CoffeeScript.load script + "?" + Math.random(), () =>
      @loadCoffeescripts(scripts, callback)

  loadJavascript: (src, callback) ->
    s = document.createElement('script')
    s.type = 'text/javascript'
    s.onload = callback
    s.src = src;
    document.body.appendChild(s)

TestSuite.inDevelopmentMode = true;
TestSuite.initialize()
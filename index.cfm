﻿


  <!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Refactored date examples</title>
  <link rel="stylesheet" href="/css/qunit-1.13.0.css">
  <script src="/js/qunit-1.13.0.js"></script>

  <script src="/js/prettydate2.js"></script>
  <script>
  test("prettydate.format", function() {
    function date(then, expected) {
      equal(prettyDate.format("2008/01/28 22:25:00", then),
        expected);
    }
    date("2008/01/28 22:24:30", "just now");
    date("2008/01/28 22:23:30", "1 minute ago");
    date("2008/01/28 21:23:30", "1 hour ago");
    date("2008/01/27 22:23:30", "Yesterday");
    date("2008/01/26 22:23:30", "2 days ago");
    date("2007/01/26 22:23:30", undefined);
  });

  test("prettyDate.update", function() {
    var links = document.getElementById("qunit-fixture")
      .getElementsByTagName("a");
    equal(links[0].innerHTML, "January 28th, 2008");
    equal(links[2].innerHTML, "January 27th, 2008");
    prettyDate.update("2008-01-28T22:25:00Z");
    equal(links[0].innerHTML, "2 hours ago");
    equal(links[2].innerHTML, "Yesterday");
  });

  test("prettyDate.update, one day later", function() {
    var links = document.getElementById("qunit-fixture")
      .getElementsByTagName("a");
    equal(links[0].innerHTML, "January 28th, 2008");
    equal(links[2].innerHTML, "January 27th, 2008");
    prettyDate.update("2008/01/29 22:25:00");
    equal(links[0].innerHTML, "Yesterday");
    equal(links[2].innerHTML, "2 days ago");
  });
  </script>
</head>
<body>

<div id="qunit"></div>
<div id="qunit-fixture">

<ul>
  <li class="entry">
    <p>blah blah blah...</p>
    <small class="extra">
      Posted <span class="time">
        <a href="/2008/01/blah/57/" title="2008-01-28T20:24:17Z"
          >January 28th, 2008</a>
      </span>
      by <span class="author"><a href="/john/">John Resig</a></span>
    </small>
  </li>
  <li class="entry">
    <p>blah blah blah...</p>
    <small class="extra">
      Posted <span class="time">
        <a href="/2008/01/blah/57/" title="2008-01-27T22:24:17Z"
          >January 27th, 2008</a>
      </span>
      by <span class="author"><a href="/john/">John Resig</a></span>
    </small>
  </li>
</ul>

</div>

</body>
</html>
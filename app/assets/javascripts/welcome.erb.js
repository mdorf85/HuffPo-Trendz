
  function makeTable(section){
    $("div.mytable").empty();

    var arr;

    switch (section){
      case "frontpage":
        arr = gon.frontpage;
        break;
      case "politics":
        arr = gon.politics;
        break;
      case "entertainment":
        arr = gon.entertainment;
        break;
      case "technology":
        arr = gon.technology;
        break;
      case "media":
        arr = gon.media;
        break;
      case "sports":
        arr = gon.sports;
        break;
    }

    size = arr.length;

    $("div.mytable").append("<h2>" + section + "</h2>");
    $("div.mytable").append("<table style='width:75%'><tr><th>Title</th><th>URL</th><th>Trending Topic</th><th># Matches</th></tr>");
    for (var i = 0; i < size; i++){
      $("div.mytable").append("<tr><td>" + arr[i].title + "</td><td>" + arr[i].url+ "</td><td>" + arr[i].topic + "</td><td>" + arr[i].matches + "</td></tr>");
    }
    $("div.mytable").append("</table>");
  }


  function makeTable(section){
    $("div#everything").empty();

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

    $("div#everything").append("<h2>" + section + "</h2>");
    // debugger;
    // $("div#everything").append("<table id='myTable'><tbody><tr><th>Title</th><th>Trending Topic</th><th># Matches</th></tr></tbody></table>");
    $("div#everything").append("<table id='myTable'></table>");
    // debugger;
    var table = document.getElementById("myTable");
    var row, header, h1, h2, h3, linkCell, topicCell, matchCell;
    row = table.insertRow(0);
    h1 = row.insertCell(0);
    h2 = row.insertCell(1);
    h3 = row.insertCell(2);
    h1.innerHTML = "<b>Title</b>";
    h2.innerHTML = "<b>Trending Topic</b>";
    h3.innerHTML = "<b># Matches</b>";
    for (var i = 0; i < size; i++){
      // debugger;
      row = table.insertRow(i + 1);
      linkCell = row.insertCell(0);
      topicCell = row.insertCell(1);
      matchCell = row.insertCell(2);
      linkCell.innerHTML = "<a href=" + arr[i].url + ">" + arr[i].title + "</a>";
      topicCell.innerHTML = arr[i].topic;
      matchCell.innerHTML = arr[i].matches;
      // ("<tr><td> + arr[i].title + "</a><a href=" + arr[i].url + ">"</td><td>" + arr[i].topic + "</td><td>" + arr[i].matches + "</td></tr>");
    }
    // debugger;
    //$("div.mytable").append("</tbody></table>");
    // debugger;
  }

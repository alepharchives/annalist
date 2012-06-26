-module(dashboard_handler).
-export([init/3, handle/2, terminate/2]).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, {}}.

handle(Req, State) ->
    {ok, Req2} = cowboy_http_req:reply(200, [], page(), Req),
    {ok, Req2, State}.

terminate(_Req, _State) ->
    ok.

page() ->
	<<"<html>\n<head>\n<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js\" type=\"text/javascript\"></script>\n<script src=\"http://www.highcharts.com/js/highstock.js\" type=\"text/javascript\"></script>\n<script type=\"text/javascript\">\n\nfunction getUrlVars()\n{\n    var vars = [], hash;\n    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');\n    for(var i = 0; i < hashes.length; i++)\n    {\n        hash = hashes[i].split('=');\n        vars.push(hash[0]);\n        vars[hash[0]] = hash[1];\n    }\n    return vars;\n}\n\nvar Now = $.now();\nvar Second = 1000;\nvar Minute = Second * 60;\nvar Hour = Minute * 60;\nvar Day = Hour * 24;\nvar Month = Day * 30;\nvar Year = Month * 12;\n\nvar Plot;\nvar SecondPlot;\nvar MinutePlot;\nvar HourPlot;\n\n(function($){ // encapsulate jQuery\n\nPlot = function(ChartId, Title, URL, StartTime, Interval) {\n\t$.getJSON( URL + '?callback=?', function(data) {\n\t\t// Create the chart\n\t\twindow.chart = new Highcharts.StockChart({\n\t\t\tchart : {\n\t\t\t\trenderTo : 'chart' + ChartId\n\t\t\t},\n\t\t\ttitle : {\n\t\t\t\ttext : Title\n\t\t\t},\t\t\t\n\t\t\tseries : [{\n\t\t\t\tanimation: false,\n\t\t\t\tpointStart: Date.UTC(StartTime.getUTCFullYear(), StartTime.getUTCMonth(), StartTime.getUTCDate(), StartTime.getUTCHours(), StartTime.getUTCMinutes(), StartTime.getUTCSeconds()),\n\t\t\t\tpointInterval: Interval,\n\t\t\t\tdata : data,\n\t\t\t\ttooltip: {\n\t\t\t\t\tyDecimals: 2\n\t\t\t\t}\n\t\t\t}]\n\t\t});\n\t})};\n}\n\n\n)(jQuery);\n\nTag = getUrlVars()[\"tag\"];\n\nSecondPlot = function(ChartId, Title, Host, Port, StartTime, ItemCount, Interval) {\n\tURL = 'http://' + Host + ':' + Port + '/annalist/second_counts/' + Tag + '/' +\n\t\tStartTime.getUTCFullYear() + '/' +\n\t\t(StartTime.getUTCMonth() + 1) + '/' +\n\t\tStartTime.getUTCDate() + '/' +\n\t\tStartTime.getUTCHours() + '/' +\n\t\tStartTime.getUTCMinutes() + '/' +\n\t\t(StartTime.getUTCSeconds() + 1) + '/' +\n\t\tItemCount;\n\tPlot(ChartId, Title, URL, StartTime, Interval);\n};\n\nMinutePlot = function(ChartId, Title, Host, Port, StartTime, ItemCount, Interval) {\n\tURL = 'http://' + Host + ':' + Port + '/annalist/minute_counts/' + Tag + '/' +\n\t\tStartTime.getUTCFullYear() + '/' +\n\t\t(StartTime.getUTCMonth() + 1) + '/' +\n\t\tStartTime.getUTCDate() + '/' +\n\t\tStartTime.getUTCHours() + '/' +\n\t\tStartTime.getUTCMinutes() + '/' +\n\t\tItemCount;\n\tPlot(ChartId, Title, URL, StartTime, Interval);\n};\n\nHourPlot = function(ChartId, Title, Host, Port, StartTime, ItemCount, Interval) {\n\tURL = 'http://' + Host + ':' + Port + '/annalist/hour_counts/' + Tag + '/' +\n\t\tStartTime.getUTCFullYear() + '/' +\n\t\t(StartTime.getUTCMonth() + 1) + '/' +\n\t\tStartTime.getUTCDate() + '/' +\n\t\tStartTime.getUTCHours() + '/' +\n\t\tItemCount;\n\tPlot(ChartId, Title, URL, StartTime, Interval);\n};\n\nif (Tag == undefined) {alert(\"Please specify a tag in the URL ('...dashboard.html?tag=my_tag')\")};\nTagsPrint = Tag.replace('%20', '/')\n\nOneHourAgo = new Date($.now() - Hour);\n// SecondPlot(1, TagsPrint + \" during Last Hour\", \"localhost\", 6060, OneHourAgo, Hour / Second, Second);\nOneDayAgo = new Date($.now() - Day);\nSecondPlot(2, TagsPrint + \" during Last Day\", \"localhost\", 6060, OneDayAgo, Day / Second, Second);\nOneMonthAgo = new Date($.now() - Month);\nMinutePlot(3, TagsPrint + \" during Last Month\", \"localhost\", 6060, OneMonthAgo, Month / Minute, Minute);\nOneYearAgo = new Date($.now() - Year);\nHourPlot(4, TagsPrint + \" during Last Year\", \"localhost\", 6060\n\t, OneYearAgo, Year / Hour, Hour);\n\n</script>\n\n\n</script>\n</head>\n<body>\n<!-- <div id=\"chart1\" style=\"width: 800px; margin-left: 10px; float: left; height: 400px\"></div> -->\n<div id=\"chart2\" style=\"width: 800px; margin-left: 10px; float: left; height: 400px\"></div>\n<div id=\"chart3\" style=\"width: 800px; margin-left: 10px; float: left; height: 400px\"></div>\n<div id=\"chart4\" style=\"width: 800px; margin-left: 10px; float: left; height: 400px\"></div>\n</html>">>.
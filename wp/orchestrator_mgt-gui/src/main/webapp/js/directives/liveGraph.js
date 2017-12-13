'use strict';
angular.module('tNovaApp')
    .directive('linearChart', function ($parse, $window) {
        return{
            restrict: 'EA',
            template: "<svg width='"+$("#graphChart").width()+"' height='200'></svg>",
            link: function (scope, elem, attrs) {
            var exp = $parse(attrs.chartData);
            
            var monitoredDataToPlot = exp(scope);
            var padding = 10;
            var pathClass = "path";
            var xScale, yScale, xAxisGen, yAxisGen, lineFun;

            var d3 = $window.d3;
            var rawSvg = elem.find('svg');
            var svg = d3.select(rawSvg[0]);
            var initial_x = monitoredDataToPlot[0].second;

            scope.$watchCollection(exp, function (newVal, oldVal) {
                monitoredDataToPlot = newVal;
                redrawLineChart();
            });

            function setChartParameters() {
                if (monitoredDataToPlot[monitoredDataToPlot.length - 1].second / monitoredDataToPlot[0].second > initial_x) {
                    initial_x++;
                }
                xScale = d3.scale.linear()
                    .domain([initial_x, monitoredDataToPlot[monitoredDataToPlot.length - 1].second])
                    .range([padding + 5, rawSvg.attr("width") - padding]);

                yScale = d3.scale.linear()
                    .domain([0, d3.max(monitoredDataToPlot, function (d) { return d.metric1;})])
                    .range([rawSvg.attr("height") - padding, 0]);

                xAxisGen = d3.svg.axis()
                    .scale(xScale)
                    .orient("bottom")
                    .ticks(monitoredDataToPlot.length - 1).tickFormat(d3.format("d"));

                yAxisGen = d3.svg.axis()
                    .scale(yScale)
                    .orient("left")
                    .ticks(5);

                lineFun = d3.svg.line()
                    .x(function (d) {return xScale(d.second);})
                    .y(function (d) { return yScale(d.metric1);})
                    .interpolate("basis");
            }

            function drawLineChart() {
                setChartParameters();

                svg.append("svg:g")
                    .attr("class", "x axis")
                        .attr("transform", "translate(0,180)")
                        .call(xAxisGen);

                    svg.append("svg:g")
                        .attr("class", "y axis")
                        .attr("transform", "translate(20,0)")
                        .call(yAxisGen);

                    svg.append("svg:path")
                        .attr({
                            d: lineFun(monitoredDataToPlot),
                            "stroke": "blue",
                            "stroke-width": 2,
                            "fill": "none",
                            "class": pathClass
                        });
                }

                function redrawLineChart() {
                    setChartParameters();
                    svg.selectAll("g.y.axis").call(yAxisGen);
                    svg.selectAll("g.x.axis").call(xAxisGen);
                    svg.selectAll("." + pathClass)
                        .attr({
                            d: lineFun(monitoredDataToPlot)
                        });
                }

                drawLineChart();
            }
            };
        })
        .directive('streamChart', function ($parse, $window) {
            return{
            restrict: 'EA',
            link: function (scope, elem, attrs) {
                var DELAY = 2000; // delay in ms to add new data points

                var exp = $parse(attrs.chartData);
                
                var monitoredDataToPlot = exp(scope);
                
                // create a graph2d with an (currently empty) dataset
                 var container = document.getElementById('visualization');
                 var dataset = new vis.DataSet();

                 var options = {
                     start: vis.moment().add(-30, 'seconds'), // changed so its faster
                     end: vis.moment(),
                     dataAxis: {
                         customRange: {
                         left: {
                             min: 0,
                         }
                         }
                     },
                     drawPoints: {
                         style: 'circle' // square, circle
                     },
                     shaded: {
                         orientation: 'bottom' // top, bottom
                     }
                 };
                 var graph2d = new vis.Graph2d(container, monitoredDataToPlot, options);

                setTimeout(renderStep, DELAY);
                function renderStep() {
                    // move the window (you can think of different strategies).
                    var now = vis.moment();
                    var range = graph2d.getWindow();
                    var interval = range.end - range.start;

                    graph2d.setWindow(now - interval, now, {animate: false});
                    setTimeout(renderStep, DELAY);
                }
            }
            };
        })
        .directive('barsChart', function ($parse, $window) {
            return{
            restrict: 'EA',
            link: function (scope, elem, attrs) {
                var DELAY = 2000; // delay in ms to add new data points

                var exp = $parse(attrs.chartData);
                
                var monitoredDataToPlot = exp(scope);
                
                // create a graph2d with an (currently empty) dataset
                var container = document.getElementById('visualization');
                var groups = new vis.DataSet();
                groups.add({id: 0, content: "Received"});
                groups.add({id: 1, content: "Mapped"});
                groups.add({id: 2, content: "Rejected"});

                var options = {
                    legend: {left:{position:"top-left"}},
                    style:'bar',
                    barChart: {width:50, align:'center', handleOverlap:"sideBySide"}, // align: left, center, right
                    drawPoints: true,
                    dataAxis: {
                        title: {left: {text: "Number of requests (#)"}},
                        customRange: {
                            left: {
                                min:-5, max:30
                            },
                            right: {
                                min:-5
                            }
                        }
                    },
                    orientation:'top',
                    start: '2015-02-05',
                    end: '2015-02-20'
                };
                var graph2d = new vis.Graph2d(container, monitoredDataToPlot, groups, options);
            }
            }
    }).directive('scatterChart', function ($parse, $window) {
        return{
            restrict: 'EA',
            link: function (scope, elem, attrs) {
                var DELAY = 2000; // delay in ms to add new data points

                var exp = $parse(attrs.chartData);
                
                var scatterDataToPlot = exp(scope);
                
                // create a graph2d with an (currently empty) dataset
                 var container = document.getElementById('scartvisualization');
                 var dataset = new vis.DataSet();

                var groups = new vis.DataSet();
                groups.add({
                    id: 0,
                    content: "Time",
                    options: {
                        drawPoints: {
                        enabled: true,
                        size: 6,
                        style: 'circle' // square, circle
                        },
                        style:'points',
                      },
                });
                groups.add({
                    id: 1,
                    content: "Average",
                    options: {drawPoints: false}
                });
                
                var dataset = new vis.DataSet(scatterDataToPlot);
                var options = {
                    legend: true,
                    sort: true,
                    sampling:false,
                    dataAxis: {
                        title: {left: {text: "Mapping time (ms)"}},
                        customRange: {
                            left: {
                                min: 10, max: 120
                            },
                            showMinorLabels: true
                        }
                    },
                    defaultGroup: 'Scatterplot',
                    height: '300px'
              };
                var graph2d = new vis.Graph2d(container, scatterDataToPlot, groups, options);
            }
            };
    }).directive('donutchart', function() {
        function createChart(el_id, options) {
            options.element = el_id;
            var r = new Morris.Donut(options).select(0);//select mapped
            return r;
        }

        return {
            restrict: 'E',
            scope:  {
            options: '='
            },
            replace: true,
            template: '<div style="height: 230px;"></div>',
            link: function(scope, element, attrs) {
            return createChart(attrs.id, scope.options)
            }
        }
  });
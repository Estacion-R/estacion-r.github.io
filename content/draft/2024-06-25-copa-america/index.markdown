---
title: Copa America
author: Pablo Tiscornia
date: '2024-06-25'
slug: copa-america
categories:
  - futbol
  - shiny
tags:
  - rstats
  - rstatsES
  - futbol
  - copaamerica
  - argentina
  - shinyapp
  - shiny
  - highcharter
draft: yes
toc: no
images: ~
---

<link href="{{< blogdown/postref >}}index_files/htmltools-fill/fill.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<link href="{{< blogdown/postref >}}index_files/brackets-viewer/brackets-viewer.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/brackets-viewer/brackets-viewer.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/brackets-viewer/stage-form-creator.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/brackets-viewer/brackets-viewer-update.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/bracketsViewer-binding/bracketsViewer.js"></script>

``` r
source(here::here("content/draft/2024-06-25-copa-america/df_copa_america.R"))
```

``` r
## Creo el grafico
brackets::bracketsViewer(df_copa_america)
```

<div class="bracketsViewer html-widget html-fill-item" id="htmlwidget-1" style="width:672px;height:480px;overflow:scroll;">
<div style="position: absolute; z-index: 1;">
<button id="htmlwidget-3399369ee8fbb61c9603-brackets-viewer-zoom-in">+</button>
<button id="htmlwidget-3399369ee8fbb61c9603-brackets-viewer-zoom-out">-</button>
</div>
<div id="htmlwidget-3399369ee8fbb61c9603-brackets-viewer" class="brackets-viewer" style="transition: transform 0.3s ease; transform-origin: top left; margin: 0;"></div>
</div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"data":{"participant":[{"id":0,"tournament_id":0,"name":"🇦🇷 Argentina"},{"id":1,"tournament_id":0,"name":"🇵🇪 Perú"},{"id":2,"tournament_id":0,"name":"🇨🇱 Chile"},{"id":3,"tournament_id":0,"name":"🇨🇦 Canada"},{"id":4,"tournament_id":0,"name":"🇻🇪 Venezuela"},{"id":5,"tournament_id":0,"name":"🇲🇽 México"},{"id":6,"tournament_id":0,"name":"🇪🇨 Ecuador"},{"id":7,"tournament_id":0,"name":"🇯🇲 Jamaica"},{"id":8,"tournament_id":0,"name":"🇺🇾 Uruguay"},{"id":9,"tournament_id":0,"name":"🇺🇸 Estados Unidos"},{"id":10,"tournament_id":0,"name":"🇵🇦 Panama"},{"id":11,"tournament_id":0,"name":"🇧🇴 Bolivia"},{"id":12,"tournament_id":0,"name":"🇧🇷 Brasil"},{"id":13,"tournament_id":0,"name":"🇨🇴 Colombia"},{"id":14,"tournament_id":0,"name":"🇵🇾 Paraguay"},{"id":15,"tournament_id":0,"name":"🇨🇷 Costa Rica"},{"id":99,"tournament_id":0,"name":"🦫"}],"stage":[{"id":0,"tournament_id":0,"name":"Copa América - Fase de grupos ⚽️","type":"round_robin","number":0,"settings":{"size":16,"grandFinal":"none","groupCount":4,"roundRobinMode":"simple","matchesChildCount":0}},{"id":1,"tournament_id":0,"name":"Llaves 🏆","type":"single_elimination","number":1,"settings":{"size":8,"seedOrdering":["natural"],"grandFinal":"simple","matchesChildCount":0}}],"group":[{"id":0,"stage_id":0,"number":1},{"id":1,"stage_id":0,"number":2},{"id":2,"stage_id":0,"number":3},{"id":3,"stage_id":0,"number":4}],"round":[{"id":0,"number":1,"stage_id":0,"group_id":0},{"id":1,"number":2,"stage_id":0,"group_id":0},{"id":2,"number":3,"stage_id":0,"group_id":0},{"id":3,"number":4,"stage_id":0,"group_id":0},{"id":4,"number":1,"stage_id":1,"group_id":0},{"id":5,"number":2,"stage_id":1,"group_id":0},{"id":6,"number":3,"stage_id":1,"group_id":0}],"match":[{"id":0,"number":0,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":0,"score":2,"result":"win"},"opponent2":{"id":3,"score":0,"result":"loss"}},{"id":1,"number":1,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":1,"score":0,"result":"draw"},"opponent2":{"id":2,"score":0,"result":"draw"}},{"id":2,"number":2,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":5,"score":1,"result":"win"},"opponent2":{"id":7,"score":0,"result":"loss"}},{"id":3,"number":3,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":6,"score":1,"result":"loss"},"opponent2":{"id":4,"score":2,"result":"win"}},{"id":4,"number":4,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":9,"score":2,"result":"win"},"opponent2":{"id":11,"score":0,"result":"loss"}},{"id":4,"number":4,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":8,"score":3,"result":"win"},"opponent2":{"id":10,"score":1,"result":"loss"}},{"id":5,"number":5,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":12,"score":0,"result":"draw"},"opponent2":{"id":15,"score":0,"result":"draw"}},{"id":6,"number":6,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":13,"score":2,"result":"win"},"opponent2":{"id":14,"score":1,"result":"loss"}},{"id":7,"number":7,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":2,"score":"-","result":""},"opponent2":{"id":0,"score":"-","result":""}},{"id":8,"number":8,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":1,"score":"-","result":""},"opponent2":{"id":3,"score":"-","result":""}},{"id":9,"number":9,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":4,"score":"-","result":""},"opponent2":{"id":5,"score":"-","result":""}},{"id":10,"number":10,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":6,"score":"-","result":""},"opponent2":{"id":7,"score":"-","result":""}},{"id":11,"number":11,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":10,"score":"-","result":""},"opponent2":{"id":9,"score":"-","result":""}},{"id":12,"number":12,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":8,"score":"-","result":""},"opponent2":{"id":11,"score":"-","result":""}},{"id":13,"number":13,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":14,"score":"-","result":""},"opponent2":{"id":12,"score":"-","result":""}},{"id":14,"number":14,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":13,"score":"-","result":""},"opponent2":{"id":15,"score":"-","result":""}},{"id":15,"number":15,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":0,"score":"-","result":""},"opponent2":{"id":1,"score":"-","result":""}},{"id":16,"number":16,"stage_id":0,"group_id":0,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":3,"score":"-","result":""},"opponent2":{"id":2,"score":"-","result":""}},{"id":17,"number":17,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":5,"score":"-","result":""},"opponent2":{"id":6,"score":"-","result":""}},{"id":18,"number":18,"stage_id":0,"group_id":1,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":7,"score":"-","result":""},"opponent2":{"id":4,"score":"-","result":""}},{"id":19,"number":19,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":9,"score":"-","result":""},"opponent2":{"id":8,"score":"-","result":""}},{"id":20,"number":20,"stage_id":0,"group_id":2,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":11,"score":"-","result":""},"opponent2":{"id":10,"score":"-","result":""}},{"id":21,"number":21,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":12,"score":"-","result":""},"opponent2":{"id":13,"score":"-","result":""}},{"id":22,"number":22,"stage_id":0,"group_id":3,"round_id":0,"child_count":0,"status":4,"opponent1":{"id":15,"score":"-","result":""},"opponent2":{"id":14,"score":"-","result":""}},{"id":23,"number":23,"stage_id":1,"group_id":0,"round_id":4,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":24,"number":24,"stage_id":1,"group_id":0,"round_id":4,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":25,"number":25,"stage_id":1,"group_id":0,"round_id":4,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":26,"number":26,"stage_id":1,"group_id":0,"round_id":4,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":27,"number":27,"stage_id":1,"group_id":0,"round_id":5,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":28,"number":28,"stage_id":1,"group_id":0,"round_id":5,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}},{"id":29,"number":29,"stage_id":1,"group_id":0,"round_id":6,"child_count":0,"status":4,"opponent1":{"id":99,"score":"-","result":""},"opponent2":{"id":99,"score":"-","result":""}}],"match_game":[]},"roundWidth":150},"evals":[],"jsHooks":[]}</script>

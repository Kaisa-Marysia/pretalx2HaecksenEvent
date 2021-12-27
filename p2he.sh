#!/usr/bin/env bash

# get with curl the json file to parse and pipe it to jq.
# get only events for one day with jq
# pipe it again trough jq to format the json so we can sort by "date"
# after all dirty oneliner to create html 
# sed the room names with regex into hyperlinks, because pretalx don't field for this.

curl "https://pretalx.c3voc.de/rc3-2021-haecksen/schedule/export/schedule.json" | \
jq '.schedule.conference|(.days|.[]|select(.date=="2021-12-27"))' | \
jq '.rooms|.[]|.[]' | \
jq -s 'sort_by(.date)' | \
jq -jr '.[] | "\t<!-- single event start -->\n<div class=\"single-event d-md-flex mt-30\">\n<div class=\"event-image\">\n<img src=\"assets/images/haecksen/hexe-icon.png\" alt=\"Event\">\n</div>\n<div class=\"event-content media-body\">\n<h4 class=\"event-title\">\n\t<a href=\"\(.url)\">\(.title)</a></h4><a class=\"scrollanchor\" name=\"\(.slug)\" href=\"#\(.slug)\">⚓</a>\n\t<p class=\"text\">\n\t\(.abstract)</p>\n\t\t<ul class=\"event-meta\">\n\t\t<li>Start: \(.start)</li>\n\t\t<li>Länge: \(.duration)</li>\n\t\t<li>Raum: <a href=\"%\(.room)%\">\(.room)</a></li>\n\t\t<li>Wer:","\(.persons[]|.public_name,",")","\n</li>\n\t\t</ul>\n\t\t</div>\n\t\t</div>\n\t\t<!-- single event end -->"''' | \
sed -e 's#%Haecksen Zur schönen Mary%#https://meeten.statt-drosseln.de/b/cri-5br-nrx-mv8#g' -e 's#%Haecksen Zur magischen Margaret%#https://meeten.statt-drosseln.de/b/cri-5br-nrx-mv8#g' -e 's#%Haecksen Stream%#https://meeten.statt-drosseln.de/b/cri-uye-ogv-vfh#g' -e 's#%Haecksen Zur großartige Ada%#https://events.haecksen.org/awesome_ada.html#g'

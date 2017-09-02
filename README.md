# NYWalker

`NYWalker` is a distributed project that aims to develop a rich database of
places mentioned in various novels. As the name suggests, the initial focus is
on novels about New York City, but the code doesn’t particularly care about New
York City. We do.

## Rationale

As the geospatial Digital Humanities matures, a lot of the work being done on
“space in literature,” as
[Franco Moretti](https://books.google.com/books?id=ja2MUXS_YQUC&printsec=frontcover&dq=moretti+space+in+literature&hl=en&sa=X&ved=0ahUKEwjP17rHmqrJAhVG2xoKHZZHD3YQ6AEIHTAA#v=onepage&q=%22space%20in%20literature%22&f=false)
refers to it, involves [named-entity recognition](https://en.wikipedia.org/wiki/Named-entity_recognition) of a giant dataset of novels.
See, for example, the work [Matt Wilkens](http://mattwilkens.com/) has done
with corpora both from the 19th and 20th centuries.

* [Git](https://git-scm.com/)
* [Node.js](https://nodejs.org/) (with NPM)
* [Ember CLI](https://ember-cli.com/)
* [Google Chrome](https://google.com/chrome/)

Instead, this software relies on time-consuming hand entry. The default setting
is not any more semantically rich than what NER would return (simply, place
name and position in text), but it is not terribly difficult to expand the
`Instance` model to include, say, a boolean for whether the instance is inside
dialog. Or part of a trip. Or to create a `Character` model who is responsible
for that instance in the text. But we’re jumping ahead of ourselves.

## Goals

We want to create a huge (geospatial) database that is of use to us
in answering questions about U.S. novels primarily related to New York City.
But we also want this database to be available to the outside world, as well.
It’s an idiosyncratic product, possibly recreating issues related to selection
bias, canonization, and the rest. But it’s a start.

Once we’re live and the database is plump with data, we’ll include information
for how one can connect to it.

In addition to the above research goals, we also use this application
pedagogically. Entering data is part of the course requirements for the
“Writing New York” course at New York University, and the software is also used
in at least one version of NYU’s “Digital Literary Studies” course. We believe
that it’s a lightweight point of entry into the (geospatial) digital
humanities, providing both instant feedback (a map!) and also encouraging
students to collaborate, act as detectives hunting down geographical data, and
the rest.

Finally, the work is public-facing, fulfilling a final pedagogical goal, of
giving students the opportunity to work on research projects with “real-world”
applications.

## Technology

`NYWalker` is a [Sinatra](http://www.sinatrarb.com) web application
that serves as a front-end to a [PostGIS](http://www.postgis.org) database. Actually, it’s currently just a postgresql database.
Researchers, that is, those who are adding data to the database, are exposed
to, effectively, three models: `Book`, `Place`, and `Instance`. An `Instance`
is an instance of a `Place` as mentioned in a `Book`. Out of the box, all we
track for `Instance`s are the `Place` and `Book` associated, along with a page
number and a sequence on the page.

`Book` is a similarly small model, keeping track of simple bibliographic
meta-data, typically funneled in from Google Books.

`Place`, on the other hand, is a very rich model. In addition to an array of
names the place is called (including nicknames, historical names, and the
like), the model also includes latitude and longitude, `geometry` that serves
up a point based on the latitude and longitude, a string that can be parsed to
create a bounding box for the place, and the place’s
[What3Words](http://what3words.com) address. `Place` leans on the
[GeoNames](http://www.geonames.org/) gazetteer as a first point of entry for
geocoding, before falling back on *Wikipedia*’s GeoHack or letting the
researcher manually add either a What3Words address or latitude and longitude.

A couple other models flesh out the application, but those three are the most important.

NYWalker also leverages [Leaflet.js](http://leafletjs.com) to display the
various places and so on in the front end. It’s expected that users (that is,
scholars who connect to the database) will use any sort of geospatial data
tools to make their analyses.

The final bit of technology is, of course, the work put in by the people making
connections and smart judgments when entering the data.

* [ember.js](https://emberjs.com/)
* [ember-cli](https://ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)

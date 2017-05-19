import Ember from 'ember';

export default Ember.Component.extend({
  model() { 
    return this.get('store').createRecord('place');
  },
  searchResultsToggle: false,
  results: {searchTerm: '', places: []},
  actions: {
    addPlace() { alert('add place!'); },
    sendPlace(place){ // to fill in the place
      this.set('name', place.name);
      this.set('lat', place.lat);
      this.set('lon', place.lon);
      this.set('bbox', place.bbox);
      this.set('geonameid', place.geonameid);
      this.set('confidence', '3');
      this.set('source', 'GeoNames');
    },
    search() { 
      let searchTerm = this.get('search');
      this.set('results.searchTerm', searchTerm);
      $.get('http://api.geonames.org/searchJSON?username=moacir&style=full&q=' + searchTerm, (data) => {
        let places = data.geonames.slice(0, 5).map( place => {
          let bBox = null;
          if (place.bbox) {
            bBox = [place.bbox.east, place.bbox.south, place.bbox.north, place.bbox.west].toString();
          }
          return {
            name: place.toponymName,
            lat: parseFloat(place.lat),
            lon: parseFloat(place.lng),
            description: place.fcodeName,
            bbox: bBox,
            geonameid: place.geonameId
          };
        });
        this.set('results.places', places);
        this.set('searchResultsToggle', true);
        this.set('results.initialCenter', [places[0].lat, places[0].lon]);
        console.log(this.get('results')); 
      });
    }
  }
});

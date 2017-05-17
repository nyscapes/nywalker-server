import Ember from 'ember';

export default Ember.Controller.extend({
  sortKey: ['page', 'sequence'],
  sortedInstances: Ember.computed.sort('model.instances', 'sortKey'),
  isMappable: Ember.computed.filter('sortedInstances', function(instance) { return instance.get('mappable'); } ),
  uniqLats: Ember.computed.uniqBy('isMappable', 'lat'),
  uniqPlaces: Ember.computed.uniqBy('uniqLats', 'lon'),
  //uniqPlaces: Ember.computed.uniqBy('isMappable', 'latLng'),
  instancePlaces: Ember.computed('sortedInstances', 'uniqPlaces', function() {
    let places = this.get('uniqPlaces');
    let instances = this.get('sortedInstances');
    let placesWithNicks = places.map(function(place) {
      let instancesWithThisPlace = instances.filter(function(instance){
        return instance.get('latLng') === place.get('latLng');
      });
      let nicknames = instancesWithThisPlace.map(function(instance){
        return instance.get('text');
      });
      let nicknamesString = nicknames.join(', ');
      place.set('nicknames', nicknamesString);
      return place;
    });
    return placesWithNicks;
  })
});

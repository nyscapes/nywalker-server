import Ember from 'ember';

export default Ember.Controller.extend({
  bounds: Ember.computed('uniqPlaces', function() {
    return L.latLngBounds(this.get('uniqPlaces').map(function(place) {
      return place.get('latLng');
    }));
  }),
  sortKey: ['page', 'sequence'],
  sortedInstances: Ember.computed.sort('model.instances', 'sortKey'),
  isMappable: Ember.computed.filter('sortedInstances', function(instance) { return instance.get('mappable'); } ),
  uniqLats: Ember.computed.uniqBy('isMappable', 'lat'),
  uniqPlaces: Ember.computed.uniqBy('uniqLats', 'lon'),
  // uniqPlaces: Ember.computed.uniqBy('isMappable', 'latLng'),
  instancePlaces: Ember.computed('sortedInstances', 'uniqPlaces', function() {
    let places = this.get('uniqPlaces');
    let instances = this.get('sortedInstances');
    let placesWithNicks = places.map(function(place) {
      let instancesWithThisPlace = instances.filter(function(instance){
        return instance.belongsTo('place').id() === place.belongsTo('place').id();
      });
      console.log(instancesWithThisPlace);
      let nicknames = instancesWithThisPlace.map(function(nickedInstance){
        return nickedInstance.get('text');
      });
      let nicknamesString = nicknames.join(', ');
      place.set('nicknames', nicknamesString);
      place.set('instancesInBook', instancesWithThisPlace.length);
      // place.set('instancesInBook', nicknames.length);
      return place;
    });
    return placesWithNicks;
  })
});

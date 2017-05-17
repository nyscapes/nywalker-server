import Ember from 'ember';

export default Ember.Controller.extend({
  bounds: Ember.computed('uniqPlaces', function() {
    return L.latLngBounds(this.get('uniqPlaces').map(place => {
      return place.get('latLng');
    }));
  }),
  sortKey: ['page', 'sequence'],
  sortedInstances: Ember.computed.sort('model.instances', 'sortKey'),
  isMappable: Ember.computed.filter('sortedInstances', instance => { return instance.get('mappable'); } ),
  uniqLats: Ember.computed.uniqBy('isMappable', 'lat'),
  uniqPlaces: Ember.computed.uniqBy('uniqLats', 'lon'),
  // uniqPlaces: Ember.computed.uniqBy('isMappable', 'latLng'),
  instancePlaces: Ember.computed('sortedInstances', 'uniqPlaces', function() {
    let instances = this.get('sortedInstances');
    return this.get('uniqPlaces').map(place => {
      let nicknames = instances.filter(instance => {
        return instance.belongsTo('place').id() === place.belongsTo('place').id();
      }).map(nickedInstance => {
        return nickedInstance.get('text');
      }).uniq();
      let nicknamesString = nicknames.join(', ');
      place.set('nicknames', nicknamesString);
      place.set('instancesInBook', nicknames.length);
      return place;
    });
  })
});

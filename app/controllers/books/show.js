import Ember from 'ember';

export default Ember.Controller.extend({
  bounds: Ember.computed('uniqPlaces', function() {
    return L.latLngBounds(this.get('uniqPlaces').map(place => {
      return place.get('latLng');
    }));
  }),
  center: Ember.computed(function(){
    return this.get('bounds').getCenter();
  }),
  zoom: 8,
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
      let nicknameObjects = nicknames.map(nickname => {
        return { text: nickname , count: instances.filter(instance => {
          return instance.belongsTo('place').id() === place.belongsTo('place').id() && nickname === instance.get('text'); }).length
        };
      });
      place.set('nicknames', nicknameObjects);
      place.set('totalInstances', nicknameObjects.reduce((a, b) => { 
        return { count: a.count + b.count }; 
      }));
      return place;
    });
  }),
  actions: {
    newCenter() { this.set('center', [41, -73]); },
    recenter(latLng) {
       this.set('center', latLng);
    }
  }
});

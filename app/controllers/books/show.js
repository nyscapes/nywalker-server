import Ember from 'ember';

export default Ember.Controller.extend({
  sortKey: ['page', 'sequence'],
  sortedInstances:Ember.computed.sort('model.instances', 'sortKey'),
  instancePlaces: Ember.computed.map('model.instances', function(instance, index) {
    if (instance.mappable) {
      return instance.latLng;
    }
  })
});

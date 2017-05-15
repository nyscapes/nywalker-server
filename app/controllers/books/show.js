import Ember from 'ember';

export default Ember.Controller.extend({
  sortKey: ['page', 'sequence'],
  sortedInstances:Ember.computed.sort('model.instances', 'sortKey')
});

import Ember from 'ember';

export default Ember.Controller.extend({
  sortKey: ['page:desc', 'sequence:desc'],
  sortedInstances: Ember.computed.sort('model.instances', 'sortKey')
});

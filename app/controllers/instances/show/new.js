import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    createInstance(instance) {
      instance.place = this.get('store').queryRecord('place', { slug: 'new-york-city' });
      instance.book = this.get('store').queryRecord('book', { slug: 'dummy-walker' });
      instance.user = this.get('store').findRecord('user', 1);
      let newInstance = this.get('store').createRecord('instance', instance);
      newInstance.save();
      this.get('sortedInstances').update();
    }
  }
});

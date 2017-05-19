import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    createInstance(instance) {
      let newInstance = this.get('store').createRecord('instance', instance);
      let place = this.get('store').queryRecord('place', { slug: 'new-york-city' });
      newInstance.set('place', place);
      newInstance.set('lat', place.get('lat'));
      newInstance.set('lon', place.get('lon'));
      newInstance.set('book', this.get('model'));
      newInstance.set('user', this.get('store').findRecord('user', 1));
      newInstance.save();
    }
  }
});

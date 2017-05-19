import Ember from 'ember';
import RSVP from 'rsvp';

export default Ember.Controller.extend({
  actions: {
    createInstance(instance) {
      let newInstance = this.get('store').createRecord('instance', instance);
      new RSVP.Promise((resolve, reject) => {
        return this.get('store').queryRecord('place', { slug: 'new-york-city' }).then((place) => {
          newInstance.set('place', place);
          newInstance.set('lat', place.get('lat'));
          newInstance.set('lon', place.get('lon'));
          // newInstance.set('lat', place.lat);
          // newInstance.set('lon', place.lon);
          resolve();
        }, reject);
      });
      // let place = this.get('store').queryRecord('place', { slug: 'new-york-city' });
      // newInstance.set('place', place);
      // newInstance.set('lat', place.get('lat'));
      // newInstance.set('lon', place.get('lon'));
      newInstance.set('book', this.get('model'));
      newInstance.set('user', this.get('loadCurrentUser')); //this.get('store').findRecord('user', 1));
      newInstance.save();
    }
  }
});

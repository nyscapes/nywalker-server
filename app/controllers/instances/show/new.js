import Ember from 'ember';

export default Ember.Controller.extend({
  theInstancePlace: null,

  actions: {
    createInstance(instance) {
      let newInstance = this.get('store').createRecord('instance', instance);
      newInstance.set('place', this.get('theInstancePlace'));
      newInstance.set('lat', this.get('theInstancePlace').get('lat'));
      newInstance.set('lon', this.get('theInstancePlace').get('lon'));
      newInstance.set('book', this.get('model'));
      this.get('store').findRecord('user', 1).then( user => {
        return newInstance.set('user', user);
      });
      // newInstance.set('user', this.get('loadCurrentUser')); //this.get('store').findRecord('user', 1));
      newInstance.save();
    }
  }
});

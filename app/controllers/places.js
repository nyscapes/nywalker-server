import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    filterByName(param) {
      if (param.length > 2) {
        return this.get('store').query('place', { name: param });
      } else {
        return this.get('store').findAll('place');
      }
    }
  }
});

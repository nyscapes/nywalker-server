import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    filterByName(param) {
      if (param.length > 2) {
        $('.infinity-loader').hide();
        return this.get('store').query('place', { name: param });
      } else {
        $('.infinity-loader').show();
        return this.get('store').findAll('place');
      }
    }
  }
});

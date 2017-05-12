import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').queryRecord('place', { slug: params.place_slug });
  }

});

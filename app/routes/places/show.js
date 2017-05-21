import Ember from 'ember';

export default Ember.Route.extend({
  renderTemplate() {
    this.render({
      into: 'places',
      outlet: 'places-show'
    });
  },
  model(params) {
    return this.get('store').queryRecord('place', { slug: params.place_slug });
  }

});

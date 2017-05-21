import Ember from 'ember';

export default Ember.Route.extend({
  renderTemplate() {
    this.render({
      into: 'places',
      outlet: 'places-show'
    });
  }
});

import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    createPlace(place) {
      let newPlace = this.get('store').createRecord('place', place);
      newPlace.set('slug', slugify(newPlace.get('name')).toLowerCase());
      newPlace.save().then(function() {
        this.transitionToRoute('places.show', newPlace);
      });
    }
  }
});

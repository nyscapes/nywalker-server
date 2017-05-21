import Ember from 'ember';
import slugify from 'npm:slugify';

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

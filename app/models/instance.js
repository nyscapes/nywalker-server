import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  page: DS.attr('number'),
  sequence: DS.attr('number'),
  text: DS.attr('string'),
  note: DS.attr('string'),
  special: DS.attr('string'),
  added_on: DS.attr('date'),
  modified_on: DS.attr('date'),
  flagged: DS.attr('boolean'),
  lat: DS.attr('number'),
  lon: DS.attr('number'),

  user: DS.belongsTo('user'),
  book: DS.belongsTo('book'),
  place: DS.belongsTo('place'),

  latlng: Ember.computed('lat', 'lon', function() {
    if (this.get('lat') === null) {
      return null;
    } else {
      return [this.get('lat'), this.get('lon')];
    }
  })

});

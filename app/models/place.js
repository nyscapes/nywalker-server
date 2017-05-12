import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  name: DS.attr('string'),
  slug: DS.attr('string'),
  confidence: DS.attr('string'),
  source: DS.attr('string'),
  geonameid: DS.attr('string'),
  what3word: DS.attr('string'),
  bounding_box_string: DS.attr('string'),
  note: DS.attr('string'),
  nickname_sentence: DS.attr('string'),
  lat: DS.attr('number'),
  lon: DS.attr('number'),
  instance_count: DS.attr('number'),
  added_on: DS.attr('date'), //?
  nicknames: DS.hasMany('nickname'),
  flagged: DS.attr('boolean'),

  latlng: Ember.computed('lat', 'lon', function() {
    return [this.get('lat'), this.get('lon')];
  })

});

import DS from 'ember-data';

export default DS.Model.extend({
  username: DS.attr('string'),
  name: DS.attr('string'),
  email: DS.attr('string'),
  admin: DS.attr('boolean'),
  places: DS.hasMany('place'),
  instances: DS.hasMany('instance')
});

import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  instance_count: DS.attr('number'),
  place: DS.belongsTo('place')
});

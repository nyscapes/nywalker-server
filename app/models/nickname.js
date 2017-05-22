import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  instance_count_query: DS.attr('number'),
  list_string: DS.attr('string'),
  place: DS.belongsTo('place')
});

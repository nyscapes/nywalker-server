import DS from 'ember-data';

export default DS.Model.extend({
  slug: DS.attr('string'),
  title: DS.attr('string'),
  author: DS.attr('string'),
  isbn: DS.attr('string'),
  year: DS.attr('number'),
  url: DS.attr('string'),
  cover: DS.attr('string'),
  added_on: DS.attr('date'),
  modified_on: DS.attr('date'),
  total_pages: DS.attr('number'),
  instance_count: DS.attr('number'),
  instances_per_page: DS.attr('number'),

  instances: DS.hasMany('instance'),
  users: DS.hasMany('user')

});

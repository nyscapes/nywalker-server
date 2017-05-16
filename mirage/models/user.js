import { Model, hasMany } from 'ember-cli-mirage';

export default Model.extend({
  books: hasMany(),
  instances: hasMany(),
  places: hasMany()
});

import Ember from 'ember';

export default Ember.Route.extend({
  baseUrl: 'localhost:9393',
  renderTemplate() {
    this.render({
      into: 'books',
      outlet: 'books-show'
    });
  },
  model(params) {
    return this.get('store').queryRecord('book', { slug: params.book_slug });
  }
});

import Ember from 'ember';

export default Ember.Route.extend({
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

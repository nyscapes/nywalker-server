import Ember from 'ember';

export default Ember.Route.extend({
  renderTemplate() {
    this.render();
    this.render('books/text', {
      into: 'books',
      outlet: 'books-show'
    });
  },
  model() {
    return this.get('store').findAll('book');
  }
});

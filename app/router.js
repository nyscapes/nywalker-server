import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('about');
  this.route('help');
  this.route('places', function() {
    this.route('show', { path: '/:place_slug' });
  });
  this.route('login');
  this.route('places-pages');
  this.route('books', function() {
    this.route('show', { path: '/:book_slug' });
  });
  this.route('instances', function() {
    this.route('show', { path: '/:book_slug' });
  });
});

export default Router;

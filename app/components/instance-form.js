import Ember from 'ember';

export default Ember.Component.extend({
  modalOpen: false,
  // search: Ember.computed(function() { 
  //   return this.get('place');
  // }),

  actions: {
    submit() { alert('hi!'); },
    openTheModal() { this.set('modalOpen', true); },
    modalClosed() {this.set('modalOpen', false); }
  }
});

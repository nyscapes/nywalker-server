import Ember from 'ember';

export default Ember.Component.extend({
  modalOpen: false,

  actions: {
    submit() { alert('hi!'); },
    openTheModal() { this.set('modalOpen', true); },
    modalClosed() {this.set('modalOpen', false); }
  }
});

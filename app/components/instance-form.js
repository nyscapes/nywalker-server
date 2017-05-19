import Ember from 'ember';

export default Ember.Component.extend({
  modalOpen: false,
  page: 2,
  // page: Ember.computed(function() {
  //   let theInstances = this.get('instances');
  //   console.log(theInstances);
  //   console.log('did u see it');
  //   // return this.get('instances').get('firstObject').page;
  // }),
  sequence: 3,

  // search: Ember.computed(function() { 
  //   return this.get('place');
  // }),

  actions: {
    submit() { 
      let instance = {
        page: this.get('page'),
        sequence: this.get('sequence'),
        text: this.get('text'),
      };
      return this.get('createInstance')(instance);
    },
    openTheModal() { this.set('modalOpen', true); },
    modalClosed() {this.set('modalOpen', false); }
  }
});

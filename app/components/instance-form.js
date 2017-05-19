import Ember from 'ember';
import RSVP from 'rsvp';

export default Ember.Component.extend({
  nicknamesList: Ember.computed( () => {
    return new RSVP.Promise((resolve, reject) => {
      $.getJSON('/api/v1/nicknames-list', (data) => {
        if (data) { // will this always work?
          resolve(data);
        } else {
          reject(new Error('failed getting nicknames-list'));
        }
      });
    }).then((data) => {
      return data.sort((a, b) => {
        return b.count - a.count;
      }).map((nick) => {
        // return `${nick.name} <span class="muted">{${nick.slug}}</span>`;
        return `${nick.name} -- {${nick.slug}}`;
      });
    });
  }),
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
    modalClosed() {this.set('modalOpen', false); },
    foo() { }
  }
});

import Ember from 'ember';
import RSVP from 'rsvp';

export default Ember.Component.extend({
  store: Ember.inject.service(),
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
  placeName: '',
  modalOpen: false,
  text: '',
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
  instanceCenter: [0, 0],
  instanceZoom: 2,
  instanceMarker: false,
  instanceMarkerCenter: [51, 0],

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
    setPlaceName(selectedPlace) { 
      this.set('placeName', selectedPlace);
      this.get('store').queryRecord('place', { slug: selectedPlace.match(/{([^}]*)}/)[1] }).then( place => { 
        this.set('text', selectedPlace.match(/(.*) -- {/)[1]);
        const latLng = [place.get('lat'), place.get('lon')];
        if (latLng[0] !== null) {
          this.set('instanceCenter', latLng);
          this.set('instanceMarkerCenter', latLng);
          this.set('instanceMarker', true);
          this.set('theInstancePlace', place);
          // this.set('instanceZoom', 8);
        } else {
          this.set('instanceMarker', false);
        }
      });
    }
  }
});

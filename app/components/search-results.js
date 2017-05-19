import Ember from 'ember';

export default Ember.Component.extend({
  zoom: 10,
  center: Ember.computed(function() { 
    return this.get('results.initialCenter'); 
  }),

  actions: {
    recenter(lat, lng){
      const latLng = [lat, lng];
      return this.set('center', latLng);
    },
    sendThisPlace(place){
      this.get('useThisPlace')(place);
    }
  }
});

import Ember from 'ember';

export default Ember.Component.extend({
  model() { 
    return this.get('store').createRecord('place');
  },
  actions: {
    addPlace() { alert('add place!'); },
    search() { 
      $.get('http://api.geonames.org/searchJSON?username=moacir&style=full&q=' + this.get('search'), (data) => {console.log(data);}); 
    },
    onChange(value, model, property) {
      alert(`${value}, ${model}, ${property}`);
    }
  }
});

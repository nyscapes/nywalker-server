import Ember from 'ember';

export default Ember.Component.extend({
  model() { 
    return this.get('store').createRecord('place');
  },
  actions: {
    addPlace() { alert('add place!'); },
    search() { alert(this.get('search')); },
    onChange(value, model, property) {
      alert(`${value}, ${model}, ${property}`);
    }
  }
});

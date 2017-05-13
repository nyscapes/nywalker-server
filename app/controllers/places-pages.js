import Ember from 'ember';

export default Ember.Controller.extend({
  pageSize: 10,
  loadHorizon: 30,
  initialReadOffset: 0,

  actions: {
    initializeReadOffset(dataset) {
      let initReadOffset = this.get('initialReadOffset');
      dataset.setReadOffset(initReadOffset);
    },
    // logDatasetState(dataset) {
    //   console.log('dataset =', dataset);
    // },
    fetch: function(pageOffset, pageSize, stats) {
      let params = {
        data_page: pageOffset,
      };
      return this.get('store').queryRecord('place', params).then((data) => {
        console.log('data');
        let meta = data.get('meta');
        stats.totalPages = meta.totalPages;
        return data.toArray();
      });
    },
    // unfetch: function(places, pageOffset) {
    //   this.store.findByIds('place', places.map(r => r.id).then(function(places) {
    //     places.forEach(place => place.deleteRecord());
    //   }));
    // }
  }
});

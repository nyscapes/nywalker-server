import Ember from 'ember';

const { inject: { service }, RSVP, Service, isEmpty } = Ember;

export default Ember.Service.extend({
  session: service('session'),
  store: service(),

  loadCurrentUser() {
    return new RSVP.Promise((resolve, reject) => {
      const accountId = this.get('session.data.authenticated.account_id');
      if (!isEmpty(accountId)) {
        return this.get('store').find('user', accountId).then((user) => {
          this.set('user', user);
          resolve();
        }, reject);
      } else {
        resolve();
      }
    });
  }
});

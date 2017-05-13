import Ember from 'ember';
import config from '../config/environment';

const { inject: { service }, Component } = Ember;

export default Ember.Component.extend({
  session: service('session'),
  actions: {
    authenticate() {
      let { identification, password } = this.getProperties('identification', 'password');
      this.get('session').authenticate('authenticator:oauth2', identification, password).catch((reason) => {
        this.set('errorMessage', reason.error);
      });
    },
  }
});

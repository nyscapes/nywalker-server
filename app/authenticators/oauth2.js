import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';
import config from '../config/environment';
import RSVP from 'rsvp';

export default OAuth2PasswordGrant.extend({
  serverTokenEndpoint: '/api/v1/token',
  serverTokenRevocationEndpoint: '/api/v1/revoke',
  makeRequest: function(url, data, headers = {}) {
    headers['Content-Type'] = 'application/vnd.api+json';
    headers['Accept'] = 'application/vnd.api+json';
    const body = JSON.stringify(data);

    const options = {
      body,
      headers,
      method: 'POST'
    };

    return new RSVP.Promise((resolve, reject) => {
      fetch(url, options).then((response) => {
        response.text().then((text) => {
          let json = text ? JSON.parse(text) : {};
          if (!response.ok) {
            response.responseJSON = json;
            reject(response);
          } else {
            resolve(json);
          }
        });
      }).catch(reject);
    });
  }
});

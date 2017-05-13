import OAuth2PasswordGrant from 'ember-simple-auth/authenticators/oauth2-password-grant';

export default OAuth2PasswordGrant.extend({
  serverTokenEndpoint: '/api/v1/token',
  serverTokenRevocationEndpoint: '/api/v1/revoke',
  makeRequest: function(url, data, headers = {}) {
    headers['Content-Type'] = 'application/vnd.api+json';
    headers['Accept'] = 'application/vnd.api+json';
    return this._super(url, data, headers);
    // const body = keys(data).map((key) => {
    //   return `${key}=${data[key]}`;
    // }).join('&');

    // const options = {
    //   body,
    //   headers,
    //   method: 'POST'
    // };

    // const clientIdHeader = this.get('_clientIdHeader');
    // if (!isEmpty(clientIdHeader)) {
    //   merge(options.headers, clientIdHeader);
    // }
    // return new RSVP.Promise((resolve, reject) => {
    //   fetch(url, options).then((response) => {
    //     response.text().then((text) => {
    //       let json = text ? JSON.parse(text) : {};
    //       if (!response.ok) {
    //         response.responseJSON = json;
    //         reject(response);
    //       } else {
    //         resolve(json);
    //       }
    //     });
    //   }).catch(reject);
    // });
  }
});

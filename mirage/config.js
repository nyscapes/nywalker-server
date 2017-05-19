import { Serializer } from 'ember-cli-mirage';

export default function() {

  // These comments are here to help you get started. Feel free to delete them.

  /*
    Config (with defaults).

    Note: these only affect routes defined *after* them!
  */

  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server

  this.namespace = 'api/v1';    // make this `/api`, for example, if your API is namespaced
  this.timing = 400;      // delay for each request, automatically set to 0 during testing

  this.get('/books/', (schema, request) => {
    if (request.queryParams.slug) {
      return schema.books.findBy({ slug: request.queryParams.slug });
    } else {
      return schema.books.all();
    }
  });
  this.get('/places', (schema, request) => {
    if (request.queryParams.slug) {
      return schema.places.findBy({ slug: request.queryParams.slug });
    } else {
      return schema.places.all();
    }
  });
  // this.get('/users');
  this.get('/users/:id');

  this.post('/instances');
  // this.post('/instances', (schema, request) => {
  //   console.log('tk');
  //   console.log(JSON.parse(request.requestBody));
  // });

  this.get('/nicknames-list', () => {
    return [
      {
        name: 'ENWHYEFFINSEE',
        slug: 'new-york-city',
        count: 1
      },
      {
        name: 'New Yurk City',
        slug: 'new-york-city',
        count: 1
      },
      {
        name: 'The Citeee',
        slug: 'new-york-city',
        count: 2
      },
      {
        name: 'The Museum',
        slug: 'museum-of-minotaurs',
        count: 1
      },
      {
        name: 'Museum of Minotaurs',
        slug: 'museum-of-minotaurs',
        count: 1
      },
      {
        name: 'BKN',
        slug: 'brooklyn',
        count: 1
      }
    ];
  });

  this.passthrough('http://api.geonames.org/**');

  /*
    Shorthand cheatsheet:

    this.get('/posts');
    this.post('/posts');
    this.get('/posts/:id');
    this.put('/posts/:id'); // or this.patch
    this.del('/posts/:id');

    http://www.ember-cli-mirage.com/docs/v0.3.x/shorthands/
  */
}

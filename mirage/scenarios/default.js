export default function(server) {

  /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.

    Make sure to define a factory for each model you want to create.
  */

  server.loadFixtures();
  let user = server.create('user', { name: 'moacir' });
  let book = server.create('book', { users: [user] });
  user.books = [book];
  let places = server.createList('place', 10);
  places.forEach(function(place){
    server.create('instance', { book }, { place });
  });
  server.createList('book', 5);

}

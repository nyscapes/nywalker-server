import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  name() {
    return faker.address.city();
  },
  slug() {
    return faker.helpers.slugify(this.name);
  },
  confidence: "3",
  // source(){
  //   return "GeoNames";
  // },
  // geonameid(){
  //   return faker.lorem.word();
  // },
  // what3word(){
  //   return faker.lorem.words();
  // },
  note() {
    return faker.lorem.paragraph();
  },
  nickname_sentence() {
    return faker.lorem.sentence();
  },
  lat() {
    return faker.address.latitude();
  },
  lon() {
    return faker.address.longitude();
  },
  instance_count() {
    return faker.random.number();
  },
  flagged: false
});

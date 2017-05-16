import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  page() {
    return 1;
  },
  sequence(i) {
    return `${i}`;
  },
  text() {
    return faker.address.city();
  },
  note() {
    return null;
  },
  special() {
    return null;
  },
  flagged() {
    return false;
  }
});

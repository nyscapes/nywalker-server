import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  username() {
    return faker.internet.userName();
  },
  name() {
    return faker.internet.findName();
  },
  email() {
    return faker.internet.exampleEmail();
  },
  admin() {
    return true;
  }
});

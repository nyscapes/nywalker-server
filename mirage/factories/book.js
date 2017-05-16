import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  title() {
    return faker.lorem.words();
  },
  slug() {
    return faker.helpers.slugify(this.title);
  },
  author() {
    return faker.name.findName();
  },
  isbn() {
    return '978' + faker.lorem.word();
  },
  year() {
    return faker.random.number();
  },
  url() {
    return faker.internet.url();
  },
  cover() {
    return faker.internet.avatar();
  },
  total_pages() {
    return faker.random.number();
  },
  instance_count() {
    return faker.random.number();
  },
  instances_per_page() {
    return faker.random.number();
  }
});

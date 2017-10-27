import { Factory, faker } from 'ember-cli-mirage';
import moment from 'moment';

export default Factory.extend({
  title() {
    return faker.company.name();
  },

  updatedAt() {
    return moment().format();
  },

  createdAt() {
    return moment().format();
  }
});

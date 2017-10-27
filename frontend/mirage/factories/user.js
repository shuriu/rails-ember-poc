import { Factory, trait, faker } from 'ember-cli-mirage';

export default Factory.extend({
  email() {
    return faker.internet.exampleEmail().toLowerCase();
  },

  withToken: trait({
    // NOTE: This is the auth token for a user.
    // This attribute is not sent by the API, and it
    // is not present on the user model. It is only used,
    // for working with mirage and testing.
    token: 'mirage-fake-token'
  }),
});

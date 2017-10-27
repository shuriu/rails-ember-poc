import { registerAsyncHelper } from '@ember/test';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

export default registerAsyncHelper('authenticatedUser', function(app, ...factoryOptions) {
  let user = server.create('user', 'withToken', ...factoryOptions);
  authenticateSession(app, { token: user.token });
  return user;
});

import Mirage from 'ember-cli-mirage';
import { isPresent } from '@ember/utils';

const {
  Response
} = Mirage;

const AUTH_TOKEN = 'mirage-fake-token';

export default function() {
  this.urlPrefix = 'http://localhost:3000';
  this.passthrough();
}

export function testConfig() {
  // Authentication requests
  this.post('sessions', ({ users }, { requestBody }) => {
    let params = JSON.parse(requestBody);
    let user   = users.findBy({ email: params.email });

    if (isPresent(user) && params.password === 'correct') {
      return { token: AUTH_TOKEN };
    } else {
      return new Response(401, {},
        {"errors":[{"code":"401","title":"Unauthorized","detail":"Missing or incorrect credentials."}]}
      );
    }
  });

  this.get('users/current', ({ users }, { requestHeaders }) => {
    let [, token] = requestHeaders.Authorization.split(/Token\s+/);

    let user = users.findBy({ token });

    if (isPresent(user)) {
      return user;
    } else {
      return new Response(401, {},
        {"errors":[{"code":"401","title":"Unauthorized","detail":"Missing or incorrect credentials."}]}
      );
    }
  });

  this.get('boards', ({ boards }) => {
    return boards.all();
  });

  this.post('boards', ({ boards }, { requestBody }) => {
    let params = JSON.parse(requestBody);
    return boards.create(params);
  });
}

import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { visit, find, fillIn, click } from 'ember-native-dom-helpers';

moduleForAcceptance('Acceptance | login');

test('visiting /login when not authenticated', async function(assert) {
  await visit('/login');
  assert.equal(currentURL(), '/login');

  let emailInput = find('[data-test-do-control=identification]');
  assert.ok(emailInput, 'email field is present');

  let passwordInput = find('[data-test-do-control=password]');
  assert.ok(passwordInput, 'password field is present');

  let submitButton = find('[data-test-submit-button]');
  assert.ok(submitButton, 'submit button is present');
});

test('visiting /login when authenticated', async function(assert) {
  authenticatedUser();
  await visit('/login');

  assert.equal(currentURL(), '/boards', 'redirected to /boards');
});

test('login with invalid credentials', async function(assert) {
  await visit('/login');

  let emailInput    = find('[data-test-do-control=identification]');
  let passwordInput = find('[data-test-do-control=password]');
  let submitButton  = find('[data-test-submit-button]');

  await fillIn(emailInput, 'incorrect@example.com');
  await fillIn(passwordInput, 'incorrect');
  await click(submitButton);

  assert.equal(currentURL(), '/login', 'still on the login page');
});

test('login with correct credentials', async function(assert) {
  server.create('user', 'withToken', { email: 'correct@example.com' });

  await visit('/login');

  let emailInput    = find('[data-test-do-control=identification]');
  let passwordInput = find('[data-test-do-control=password]');
  let submitButton  = find('[data-test-submit-button]');

  await fillIn(emailInput, 'correct@example.com');
  await fillIn(passwordInput, 'correct');
  await click(submitButton);

  assert.equal(currentURL(), '/boards', 'redirected to /boards');
});

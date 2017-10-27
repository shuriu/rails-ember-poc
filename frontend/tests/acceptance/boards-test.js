import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { visit, find, findAll, fillIn, click, triggerEvent } from 'ember-native-dom-helpers';

moduleForAcceptance('Acceptance | boards');

test('visiting /boards', async function(assert) {
  authenticatedUser();
  await visit('/boards');
  assert.equal(currentURL(), '/boards');

  let newBoardLink = find('.data-new-board');
  assert.ok(newBoardLink, 'new board link present');

  let noBoardsText = find('.no-boards-text');
  assert.ok(noBoardsText, 'no boards text present');
});

test('adding a board', async function(assert) {
  authenticatedUser();
  await visit('/boards');
  let newBoardLink = find('.data-new-board');

  // Test opening and closing
  await click(newBoardLink);
  assert.ok(find('[data-test-modal-title]'), 'modal title present');
  let closeIcon = find('[data-test-close-icon]');
  assert.ok(closeIcon, 'close icon is present');
  await click(closeIcon);
  assert.notOk(find('[data-test-modal-title]'), 'modal title absent');

  await click(newBoardLink);
  assert.ok(find('[data-test-modal-title]'), 'modal title present');
  let closeButton = find('[data-test-close]');
  assert.ok(closeButton, 'close button is present');
  await click(closeButton);
  assert.notOk(find('[data-test-modal-title]'), 'modal title absent');

  // Test adding a board
  await click(newBoardLink);
  assert.ok(find('[data-test-do-control=title]'), 'title field is present');
  assert.ok(find('[data-test-save]'), 'submit button is present');

  await fillIn(find('[data-test-do-control=title]'), 'MyBoard');
  await triggerEvent(find('[data-test-do-control=title]'), 'blur');
  await click(find('[data-test-save]'));

  assert.notOk(find('[data-test-modal-title]'), 'modal title absent');
  assert.equal(1, findAll('[data-test-board-title]').length, 'added 1 board');

  await click(newBoardLink);
  await fillIn(find('[data-test-do-control=title]'), 'MyBoard2');
  await triggerEvent(find('[data-test-do-control=title]'), 'blur');
  await click(find('[data-test-save]'));
  assert.equal(2, findAll('[data-test-board-title]').length, 'added 2 boards');
});

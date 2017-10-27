import EmberObject from '@ember/object';
import BoardValidationsMixin from 'frontend/mixins/board-validations';
import { module, test } from 'qunit';

module('Unit | Mixin | board validations');

// Replace this with your real tests.
test('it works', function(assert) {
  let BoardValidationsObject = EmberObject.extend(BoardValidationsMixin);
  let subject = BoardValidationsObject.create();
  assert.ok(subject);
});

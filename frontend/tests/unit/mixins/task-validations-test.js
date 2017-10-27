import EmberObject from '@ember/object';
import TaskValidationsMixin from 'frontend/mixins/task-validations';
import { module, test } from 'qunit';

module('Unit | Mixin | task validations');

// Replace this with your real tests.
test('it works', function(assert) {
  let TaskValidationsObject = EmberObject.extend(TaskValidationsMixin);
  let subject = TaskValidationsObject.create();
  assert.ok(subject);
});

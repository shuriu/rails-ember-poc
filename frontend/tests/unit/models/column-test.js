import { moduleForModel, test } from 'ember-qunit';

moduleForModel('column', 'Unit | Model | column', {
  needs: [
    'validator:presence'
  ]
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

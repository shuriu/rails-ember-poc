import { moduleFor, test } from 'ember-qunit';

moduleFor('route:board', 'Unit | Route | board', {
  needs: [
    'service:session'
  ]
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});

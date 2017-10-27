import { moduleFor, test } from 'ember-qunit';

moduleFor('route:boards', 'Unit | Route | boards', {
  needs: [
    'service:session'
  ]
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});

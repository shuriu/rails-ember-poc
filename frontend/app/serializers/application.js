import DS from 'ember-data';
import { get } from '@ember/object';

export default DS.JSONAPISerializer.extend({
  // Serialize only new records or dirty attributes by default
  serializeAttribute(snapshot, json, key) {
    if (get(snapshot.record, 'isNew') || snapshot.changedAttributes()[key]) {
      this._super(...arguments);
    }
  }
});

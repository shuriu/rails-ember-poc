import Component from '@ember/component';
import { inject } from '@ember/service';
import { get } from '@ember/object';

export default Component.extend({
  tagName: '',
  session: inject('session'),
  currentUser: inject('current-user'),

  actions: {
    invalidateSession() {
      get(this, 'session').invalidate();
    }
  }
});

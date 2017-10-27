import Ember from 'ember';

const {
  get,
  inject: { service },
  RSVP,
  set,
  Service
} = Ember;

export default Service.extend({
  session: service('session'),
  store: service(),

  load() {
    return new RSVP.Promise((resolve) => {
      if (!get(this, 'session.isAuthenticated')) {
        return resolve();
      }

      return get(this, 'store').queryRecord('user', { current: true }).then((user) => {
        set(this, 'user', user);
        return resolve(user);
      }, (reason) => {
        return resolve(reason);
      });
    });
  }
});

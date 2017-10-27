import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const {
  get,
  inject: { service },
  Route
} = Ember;

export default Route.extend(ApplicationRouteMixin, {
  currentUser: service(),
  routeAfterAuthentication: 'dashboard',

  beforeModel() {
    return this.loadCurrentUser();
  },

  sessionAuthenticated() {
    this._super(...arguments);

    return this.loadCurrentUser();
  },

  loadCurrentUser() {
    return get(this, 'currentUser').load()
      .catch(() => get(this, 'session').invalidate());
  },
});


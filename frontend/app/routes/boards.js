import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return this.get('store').findAll('board');
  },

  setupController(controller, model) {
    this._super(...arguments);
    controller.set('boards', model);
    controller.set('showModal', false);
  },

  actions: {
    showModal() {
      this.controllerFor('boards').set('showModal', true);
    }
  }
});

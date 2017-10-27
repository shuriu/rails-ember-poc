import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {
  model(params) {
    return this.get('store').findRecord('board', params.id, { include: 'columns,columns.tasks'});
  },

  setupController(controller, model) {
    this._super(...arguments);
    controller.set('board', model);
  }
});

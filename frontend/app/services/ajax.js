import Ember from 'ember';
import AjaxService from 'ember-ajax/services/ajax';
import ENV from '../config/environment';

const {
  computed,
  get,
  inject: { service }
} = Ember;

export default AjaxService.extend({
  session: service('session'),

  host: ENV.APP.host,
  contentType: 'application/json',
  dataType: 'json',

  headers: computed('session.data.authenticated.token', {
    get() {
      let headers = {};
      let token = get(this, 'session.data.authenticated.token');

      if (token) {
        headers.Authorization = `Token ${token}`;
      }
      return headers;
    }
  })
});

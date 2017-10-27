import Component from '@ember/component';
import Ember from 'ember';
import { buildValidations, validator } from 'ember-cp-validations';
import { task } from 'ember-concurrency';

const {
  inject: { service },
  get,
  getProperties,
  setProperties
} = Ember;

const Validations = buildValidations({
  identification: {
    description: 'Email',
    validators: [
      validator('presence', true),
      validator('format', {
        allowBlank: true,
        type: 'email'
      })
    ]
  },
  password: {
    description: 'Password',
    validators: [
      validator('presence', true)
    ]
  }
});

export default Component.extend(Validations, {
  session: service('session'),

  emailAuthentication: task(function* () {
    let credentials = getProperties(this, 'identification', 'password');

    if (get(this, 'validations.isValid')) {
      try {
        yield get(this, 'session').authenticate('authenticator:token', credentials);
      } catch(e) {
        // Eat error
      } finally {
        setProperties(this, {
          identification: null,
          password: null
        });
      }
    }
  }).drop()
});

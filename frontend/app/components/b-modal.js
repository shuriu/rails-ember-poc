import Ember from 'ember';
import Component from '@ember/component';
import { computed, get, set } from '@ember/object';

const {
  testing
} = Ember;

export default Component.extend({
  open: true,
  overlayClose: true,

  _backdropDestination: computed(function() {
    return testing ? 'ember-testing' : 'boardz-application';
  }).readOnly(),

  click(event) {
    event.preventDefault();
    let overlayClose = get(this, 'overlayClose');
    let onClose = get(this, 'onClose');
    let target = Ember.$(event.target);

    if (overlayClose && target.hasClass('modal show d-block')) {
      set(this, 'open', false);

      if (onClose) {
        return onClose(event);
      }
    }
  }
});

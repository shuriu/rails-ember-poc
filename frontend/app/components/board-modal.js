import Component from '@ember/component';
import { inject } from '@ember/service';
import { computed, get } from '@ember/object';
import { isPresent } from '@ember/utils';
import BoardValidations from 'frontend/mixins/board-validations';

const BoardModal = Component.extend(BoardValidations, {
  store: inject('store'),
  router: inject('router'),

  open: false,
  model: null,

  title: '',

  resource: computed('model', function() {
    let model = get(this, 'model');
    return isPresent(model) ? model : this;
  }).readOnly(),

  actions: {
    save() {
      let model  = get(this, 'model');
      let router = get(this, 'router');

      if (isPresent(model) && get(model, 'validations.isValid')) {
        model.save().then(() => {
          router.transitionTo('boards');
        });
      } else {
        if (get(this, 'validations.isValid')) {
          let store = get(this, 'store');

          let instance = store.createRecord('board', {
            title: get(this, 'title')
          });

          instance.save().then(() => {
            router.transitionTo('boards');
          }, () => {
            instance.unloadRecord();
          })
        }
      }
    },

    close() {
      let model = get(this, 'model');
      let router = get(this, 'router');

      if (isPresent(model)) {
        model.rollbackAttributes();
      }

      router.transitionTo('boards');
    }
  }
});

BoardModal.reopenClass({
  positionalParams: ['model']
});

export default BoardModal;

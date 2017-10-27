import Component from '@ember/component';
import { inject } from '@ember/service';
import { get, set } from '@ember/object';
import ColumnValidations from 'frontend/mixins/column-validations';

const ColumnForm = Component.extend(ColumnValidations, {
  store: inject('store'),

  title: '',
  isAdding: false,

  actions: {
    startAdding() {
      set(this, 'isAdding', true);
    },

    stopAdding() {
      set(this, 'isAdding', false);
    },

    save() {
      this.validate().then(({ validations }) => {
        if (get(validations, 'isValid')) {
          let column = get(this, 'store').createRecord('column', {
            title: get(this, 'title'),
            board: get(this, 'board')
          });

          column.save().then(() => {
            set(this, 'title', '');
            set(this, 'isAdding', false);
          });
        }
      });
    }
  }
});

ColumnForm.reopenClass({
  positionalParams: ['board']
});

export default ColumnForm;

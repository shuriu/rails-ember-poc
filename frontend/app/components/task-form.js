import Component from '@ember/component';
import { inject } from '@ember/service';
import { get, set } from '@ember/object';
import TaskValidations from 'frontend/mixins/task-validations';

const TaskForm = Component.extend(TaskValidations, {
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
          let column = get(this, 'store').createRecord('task', {
            title: get(this, 'title'),
            column: get(this, 'column')
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

TaskForm.reopenClass({
  positionalParams: ['column']
});

export default TaskForm;

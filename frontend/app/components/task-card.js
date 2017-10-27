import Component from '@ember/component';
import { get, set } from '@ember/object';

const TaskCard = Component.extend({
  tagName: 'li',
  classNames: ['list-group-item', 'my-1', 'd-flex', 'justify-content-between'],
  isHovering: false,

  mouseEnter() {
    set(this, 'isHovering', true);
  },

  mouseLeave() {
    set(this, 'isHovering', false);
  },

  actions: {
    startEditing() {
      set(this, 'isEditing', true);
    },

    stopEditing() {
      set(this, 'isEditing', false);
      get(this, 'task').rollbackAttributes();
    },

    save() {
      let task = get(this, 'task');

      task.validate().then(({ validations }) => {
        if (validations.get('isValid')) {
          task.save().then(() => {
            set(this, 'isEditing', false);
          });
        }
      })
    },

    destroy() {
      get(this, 'task').destroyRecord();
    }
  }
});

TaskCard.reopenClass({
  positionalParams: ['task']
});

export default TaskCard;

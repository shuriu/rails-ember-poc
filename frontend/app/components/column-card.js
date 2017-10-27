import Component from '@ember/component';
import { get, set } from '@ember/object';

const ColumnCard = Component.extend({
  classNames: [
    'col-3',
    'ml-3',
    'border',
    'border-dark',
    'bg-info'
  ],

  isHovering: false,

  mouseEnter() {
    set(this, 'isHovering', true);
  },

  mouseLeave() {
    set(this, 'isHovering', false);
  },

  actions: {
    destroy() {
      get(this, 'column').destroyRecord();
    },

    startEditing() {
      set(this, 'isEditing', true);
    },

    stopEditing() {
      let column = get(this, 'column');
      set(this, 'isEditing', false);
      column.rollbackAttributes();
    },

    save() {
      let column = get(this, 'column');

      column.validate().then(({ validations }) => {
        if (validations.get('isValid')) {
          column.save().then(() => {
            set(this, 'isEditing', false);
          });
        }
      })
    }
  }
});

ColumnCard.reopenClass({
  positionalParams: ['column']
})

export default ColumnCard;

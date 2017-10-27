import Component from '@ember/component';
import { get, set } from '@ember/object';
import { task } from 'ember-concurrency';

const BoardCard = Component.extend({
  isHovering: false,

  mouseEnter() {
    set(this, 'isHovering', true);
  },

  mouseLeave() {
    set(this, 'isHovering', false);
  },

  deleteTask: task(function*() {
    yield get(this, 'board').destroyRecord();
  }).drop(),

  actions: {
    delete() {
      try {
        get(this, 'deleteTask').perform();
      } catch(e) {
        // Eat the error
      }
    }
  }
});

BoardCard.reopenClass({
  positionalParams: ['board']
});

export default BoardCard;

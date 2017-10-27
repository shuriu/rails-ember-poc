import Component from '@ember/component';

export default Component.extend({
  modalOpened: false,

  actions: {
    closeModal() {
      this.set('modalOpened', false);
    }
  }
});

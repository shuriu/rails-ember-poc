import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
  urlForQueryRecord(query) {
    if (query.current) {
      delete query.current;
      return `${this._super(...arguments)}/current`;
    }
    return this._super(...arguments);
  },

  urlForUpdateRecord(id, modelName, snapshot) {
    if (snapshot.adapterOptions && snapshot.adapterOptions.current) {
      return this._super('current', modelName, snapshot);
    }
    return this._super(...arguments);
  }
});

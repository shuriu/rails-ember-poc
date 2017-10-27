import DS from 'ember-data';
import TaskValidations from 'frontend/mixins/task-validations';

const {
  Model,
  attr,
  belongsTo
} = DS;

export default Model.extend(TaskValidations, {
  title:     attr('string'),
  updatedAt: attr('date'),
  createdAt: attr('date'),

  column: belongsTo('column')
});

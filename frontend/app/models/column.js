import DS from 'ember-data';
import ColumnValidations from 'frontend/mixins/column-validations';

const {
  Model,
  attr,
  hasMany,
  belongsTo
} = DS;

export default Model.extend(ColumnValidations, {
  title:     attr('string'),
  updatedAt: attr('date'),
  createdAt: attr('date'),

  board: belongsTo('board'),
  tasks:  hasMany('task')
});

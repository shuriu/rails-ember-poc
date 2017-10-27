import DS from 'ember-data';
import BoardValidations from 'frontend/mixins/board-validations';

const {
  Model,
  attr,
  hasMany,
  belongsTo
} = DS;

export default Model.extend(BoardValidations, {
  title: attr('string'),
  updatedAt: attr('date'),

  user: belongsTo('user'),
  columns: hasMany('column')
});

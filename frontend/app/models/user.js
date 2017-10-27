import DS from 'ember-data';

const {
  Model,
  attr,
  hasMany
} = DS;

export default Model.extend({
  email: attr('string'),
  boards: hasMany('board')
});

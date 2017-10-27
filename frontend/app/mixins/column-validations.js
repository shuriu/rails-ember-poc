import { validator, buildValidations } from 'ember-cp-validations';

const ColumnValidations = buildValidations({
  title: {
    description: 'Column title',
    validators: [
      validator('presence', true)
    ]
  }
});

export default ColumnValidations;

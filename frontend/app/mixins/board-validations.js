import { validator, buildValidations } from 'ember-cp-validations';

const BoardValidations = buildValidations({
  title: {
    description: 'Board title',
    validators: [
      validator('presence', true)
    ]
  }
});

export default BoardValidations;

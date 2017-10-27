import { validator, buildValidations } from 'ember-cp-validations';

const TaskValidations = buildValidations({
  title: {
    description: 'Task title',
    validators: [
      validator('presence', true)
    ]
  }
});

export default TaskValidations;

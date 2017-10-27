# Boards

Proof of concept application similar to [Trello](https://trello.com/).

The backend is Ruby on Rails and the frontend is Ember.

## Features
* Boards CRUD
* Panels (Columns) CRUD
* Tasks (Cards) CRUD
* Authentication via `email` / `password`
* Backend tests (models, controllers, concerns, json schema validation)
* Frontend tests (acceptance)

## Prerequisites

You will need the following things properly installed on your computer.

* `ruby -v 2.4.2`
* `postgresql -v 9.x`
* `rails -v 5.1.4`
* `node -v 8.x.x`
* `ember-cli -v 2.16.2` (via `yarn` preferably)

## Installation

* `git clone <repository-url>`
* `cd <repository>/backend`
* `bundle install`
* `rails db:setup && rails db:seed`
* `cd <repository>/frontend`
* `yarn`

## Running / Development

First run the backend:
* `cd backend && rails s`

And for the frontend:
* `cd frontend && rails s`

You now have the backend API accepting request from the frontend application:
* Visit app at [http://localhost:4200](http://localhost:4200).

### Running Tests

Backend tests:
* Run them once via `rails test`
* Run on file changes: `bundle exec guard`

Frontend tests:
* Run once `ember test`
* Or you can see live tests at [http://localhost:4200/tests](http://localhost:4200/tests).
* BONUS: You don't need the backend running for the frontend tests

### Roadmap
- [ ] More frontend acceptance tests
- [ ] Ability to drag and drop columns and persist their position
- [ ] Ability to drag and drop tasks inside a column and persist their position
- [ ] Ability to drag and drop tasks between columns and persist their position
- [ ] Improve JSON schema validation

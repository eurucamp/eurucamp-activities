import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.findAll('activity');
  },
  activate: function() {
    Ember.$('body').addClass('activities index');
  },
  deactivate: function() {
    Ember.$('body').removeClass('activities index');
  }
});

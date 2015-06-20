import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('activity', params.activity_id);
  },
  activate: function() {
    Ember.$('body').addClass('activities show');
  },
  deactivate: function() {
    Ember.$('body').removeClass('activities show');
  }
});

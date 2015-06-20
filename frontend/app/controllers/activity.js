import Ember from 'ember';

export default Ember.Controller.extend({
  roomLeft: function() {
    return `Still room for ${this.get('model.openSpots')} people`;
  }.property('model.openSpots')
});

import Ember from 'ember';
import UnauthenticatedRouteMixin from 'simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  activate: function() {
    Ember.$('body').addClass('user sessions new');
  },
  deactivate: function() {
    Ember.$('body').removeClass('user sessions new');
  }
});

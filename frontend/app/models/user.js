import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr(),
  name: DS.attr(),
  twitterHandle: DS.attr(),
  githubHandle: DS.attr(),
  avatar: DS.attr()
});

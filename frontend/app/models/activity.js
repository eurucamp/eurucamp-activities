import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  requirements: DS.attr(),
  location: DS.attr(),
  anytime: DS.attr('boolean'),
  startTime: DS.attr('date'),
  endTime: DS.attr('date'),
  participationsCount: DS.attr('number', { default: 0 }),
  limitOfParticipants: DS.attr('number'),
  imageUrl: DS.attr(),

  creator: DS.belongsTo('user', { async: false }),
  participants: DS.hasMany('user'),

  openSpots: function() {
    return this.get('limitOfParticipants') - this.get('participationsCount');
  }.property('limitOfParticipants', 'participationsCount')
});

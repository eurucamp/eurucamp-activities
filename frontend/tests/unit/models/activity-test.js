import { moduleForModel, test } from 'ember-qunit';

moduleForModel('activity', 'Unit | Model | activity', {
  needs: ['model:user']
});

test('openSpots', function(assert) {
  var activity = this.subject({
    participationsCount: 19,
    limitOfParticipants: 20
  });

  assert.equal(activity.get('openSpots'), 1);
});

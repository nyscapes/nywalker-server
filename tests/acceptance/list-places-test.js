import { test } from 'qunit';
import moduleForAcceptance from 'nywalker/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | list places');

test('visiting /places', function(assert) {
  visit('/places');

  andThen(function() {
    assert.equal(currentURL(), '/places');
  });
});

test('should show a list of places', function(assert){});

test('should filter the list of places', function(assert){
  visit('/places');
  fillIn('.place-filter input', 'Moscow');
  keyEvent('.place-filter input', 'keyup', 69);

  andThen(function() {
    assert.equal(find('.place').length, 1, 'should show 1 place');
    assert.equal(find('.place .location:contains("Moscow")').length, 1, 'should contain 1 listing with location Moscow');
  });
});


test('should show a map with all the places', function(assert){});


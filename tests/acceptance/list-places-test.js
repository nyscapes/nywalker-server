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

test('should show a map with all the places', function(assert){});


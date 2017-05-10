import { test } from 'qunit';
import moduleForAcceptance from 'nywalker/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | nav bar');

// test('navbar is visible', function(assert) {
//   visit('/');

//   andThen(function() {
//     assert.equal(currentURL(), '/nav-bar');
//   });
// });

test('About button leads to About', function(assert) {
  visit('/');
  click('a:contains("About")'); 

  andThen(function() {
    assert.equal(currentURL(), '/about');
  });
});

test('Help button leads to Help', function(assert) {
  visit('/');
  click('a:contains("Help")'); 

  andThen(function() {
    assert.equal(currentURL(), '/help');
  });
});

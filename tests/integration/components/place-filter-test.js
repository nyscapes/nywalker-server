import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import wait from 'ember-test-helpers/wait';
import RSVP from 'rsvp';

const ITEMS = [{name: 'New York City'}, {name: 'New York'}, {name: 'Moscow'}];
const RESULTS = [{name: 'Moscow'}];

moduleForComponent('place-filter', 'Integration | Component | place filter', {
  integration: true
});

test('it should initially load all places', function(assert) {
  // We return promises
  this.on('filterByName', (val) => {
    if (val === ''){
      return RSVP.resolve(ITEMS);
    } else {
      return RSVP.resolve(RESULTS);
    }
  });

	// with an integration test,
  // you can set up and use your component in the same way your application will use it.
  this.render(hbs`
    {{#place-filter filter=(action 'filterByName') as |results|}}
      <ul>
      {{#each results as |item|}}
        <li class="place">
          {{item.name}}
        </li>
      {{/each}}
      </ul>
    {{/place-filter}}
  `);

  return wait().then(() => {
    assert.equal(this.$('.place').length, 3);
    assert.equal(this.$('.place').first().text().trim(), 'New York City');
  });

});

// test('it renders', function(assert) {

//   // Set any properties with this.set('myProperty', 'value');
//   // Handle any actions with this.on('myAction', function(val) { ... });

//   this.render(hbs`{{place-filter}}`);

//   assert.equal(this.$().text().trim(), '');

//   // Template block usage:
//   this.render(hbs`
//     {{#place-filter}}
//       template block text
//     {{/place-filter}}
//   `);

//   assert.equal(this.$().text().trim(), 'template block text');
// });

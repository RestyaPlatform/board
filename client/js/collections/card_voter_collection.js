if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Voter Collection
 * @class CardVoterCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardVoterCollection = Backbone.Collection.extend({
    model: App.CardVoter
});

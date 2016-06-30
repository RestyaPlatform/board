if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card User Collection
 * @class CardUserCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardUserCollection = Backbone.Collection.extend({
    model: App.CardUser
});

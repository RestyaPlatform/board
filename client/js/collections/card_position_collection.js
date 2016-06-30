if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card position Collection
 * @class CardPositionCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardPositionCollection = Backbone.Collection.extend({
    model: App.Position
});

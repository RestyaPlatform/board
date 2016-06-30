if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Label Collection
 * @class CardLabelCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardLabelCollection = Backbone.Collection.extend({
    model: App.Label
});

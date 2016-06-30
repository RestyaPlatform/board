if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Subscriber Collection
 * @class CardSubscriberCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardSubscriberCollection = Backbone.Collection.extend({
    model: App.CardSubscriber
});

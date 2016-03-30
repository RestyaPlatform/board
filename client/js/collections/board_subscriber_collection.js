if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board Subscriber Collection
 * @class BoardSubscriberCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.BoardSubscriberCollection = Backbone.Collection.extend({
    model: App.BoardSubscriber
});

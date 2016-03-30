if (typeof App === 'undefined') {
    App = {};
}
/**
 * List Subscriber Collection
 * @class ListSubscriberCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ListSubscriberCollection = Backbone.Collection.extend({
    model: App.ListSubscriber
});

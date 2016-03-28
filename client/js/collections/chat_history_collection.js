if (typeof App == 'undefined') {
    App = {};
}
/**
 * ChatHistory Collection
 * @class ChatHistoryCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ChatHistoryCollection = Backbone.Collection.extend({
    model: App.ChatHistory
});

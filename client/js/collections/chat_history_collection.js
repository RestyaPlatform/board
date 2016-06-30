if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChatHistory Collection
 * @class ChatHistoryCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ChatHistoryCollection = Backbone.Collection.extend({
    model: App.ChatHistory,
    parse: function(response) {
        if (!_.isUndefined(response._metadata)) {
            return response.data;
        }
        return response;
    }
});

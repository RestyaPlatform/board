if (typeof App === 'undefined') {
    App = {};
}
/**
 * Oauth Client Collection
 * @class OauthClientCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.OauthClientCollection = Backbone.Collection.extend({
    model: App.OauthClient,
    parse: function(response) {
        if (!_.isUndefined(response._metadata)) {
            return response.data;
        }
        return response;
    }
});

if (typeof App === 'undefined') {
    App = {};
}
/**
 * Oauth Application Collection
 * @class OauthClientCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.OauthApplicationCollection = Backbone.Collection.extend({
    model: App.OauthApplication,
    parse: function(response) {
        if (!_.isUndefined(response._metadata)) {
            return response.data;
        }
        return response;
    }
});

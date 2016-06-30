if (typeof App === 'undefined') {
    App = {};
}
/**
 * OAuth Model
 * @class OAuth
 * @constructor
 * @extends Backbone.Model
 */
App.OAuth = Backbone.Model.extend({
    url: function() {
        return api_url + 'oauth.json';
    }
});

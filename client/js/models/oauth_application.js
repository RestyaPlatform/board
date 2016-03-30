if (typeof App === 'undefined') {
    App = {};
}
/**
 * Oauth Application Model
 * @class OauthClient
 * @constructor
 * @extends Backbone.Model
 */
App.OauthApplication = Backbone.Model.extend({
    idAttribute: 'client_id',
});

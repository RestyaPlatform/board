if (typeof App === 'undefined') {
    App = {};
}
/**
 * ACL Model
 * @class ACL
 * @constructor
 * @extends Backbone.Model
 */
App.ACL = Backbone.Model.extend({
    initialize: function() {
        this.acl_links_roles = new App.RoleSettingsCollection();
    }
});

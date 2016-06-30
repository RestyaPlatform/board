if (typeof App === 'undefined') {
    App = {};
}
/**
 * Role Model
 * @class Role
 * @constructor
 * @extends Backbone.Model
 */
App.AclOrganizationLinks = Backbone.Model.extend({
    initialize: function() {
        this.acl_organization_links_organizations_user_roles = new App.AclOrganizationLinksCollection();
    }
});

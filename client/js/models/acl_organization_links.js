if (typeof App == 'undefined') {
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
        this.acl_board_links_boards_user_roles = new App.AclOrganizationLinksCollection();
    }
});

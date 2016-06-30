if (typeof App === 'undefined') {
    App = {};
}
/**
 * Organization Model
 * @class Organization
 * @constructor
 * @extends Backbone.Model
 */
App.Organization = Backbone.Model.extend({
    initialize: function(args) {
        this.boards = new App.BoardCollection();
        this.board_users = new App.BoardsUserCollection();
        this.organizations_users = new App.OrganizationsUserCollection();
        this.acl_links = new App.AclOrganizationLinksCollection();
    }
});

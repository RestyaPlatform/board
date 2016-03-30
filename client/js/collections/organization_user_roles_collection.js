if (typeof App === 'undefined') {
    App = {};
}
/**
 * Organization User Roles Collection
 * @class OrganizationUserRolesCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.OrganizationUserRolesCollection = Backbone.Collection.extend({
    model: App.OrganizationUserRoles
});

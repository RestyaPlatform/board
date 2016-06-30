if (typeof App === 'undefined') {
    App = {};
}
/**
 * Board User Roles Collection
 * @class BoardUserRolesCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.BoardUserRolesCollection = Backbone.Collection.extend({
    model: App.BoardUserRoles
});

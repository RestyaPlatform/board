if (typeof App === 'undefined') {
    App = {};
}
/**
 * Role Collection
 * @class RoleCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.RoleCollection = Backbone.Collection.extend({
    model: App.Role
});

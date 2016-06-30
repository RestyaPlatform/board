if (typeof App === 'undefined') {
    App = {};
}
/**
 * Role Collection
 * @class RoleCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.RoleSettingsCollection = Backbone.Collection.extend({
    model: App.RoleSetting
});

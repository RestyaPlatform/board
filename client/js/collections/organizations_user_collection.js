if (typeof App === 'undefined') {
    App = {};
}
/**
 * Organizations User Collection
 * @class OrganizationsUserCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.OrganizationsUserCollection = Backbone.Collection.extend({
    model: App.OrganizationsUser,
    saved: function() {
        return this.reject(function(organizations_user) {
            return organizations_user.isNew();
        });
    }
});

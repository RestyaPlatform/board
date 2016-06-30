if (typeof App === 'undefined') {
    App = {};
}
/**
 * Acl Organization Links Collection
 * @class AclOrganizationLinksCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.AclOrganizationLinksCollection = Backbone.Collection.extend({
    model: App.AclOrganizationLinks
});
